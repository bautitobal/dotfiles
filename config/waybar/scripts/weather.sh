#!/bin/bash

# TODO: Configure your .env in ~/dotfiles/.env nor change the dir below:
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
if [ -f "$DOTFILES_DIR/.env" ]; then
  source "$DOTFILES_DIR/.env"
else
  echo '{"text":"","class":"error","tooltip":"Archivo .env no encontrado"}' | tr -d '\n'
  exit 1
fi

# Validating your env variables
if [ -z "$OPENWEATHER_API_KEY" ] || [ -z "$OPENWEATHER_CITY_ID" ]; then
  echo '{"text":"","class":"error","tooltip":"Configuración incompleta en .env"}' | tr -d '\n'
  exit 1
fi


UNITS="metric" # Imagine using imperial system lmao.
UNIT_SYMBOL="°C"
LANG="es"

URL="https://api.openweathermap.org/data/2.5/weather?id=${OPENWEATHER_CITY_ID}&appid=${OPENWEATHER_API_KEY}&units=${UNITS}&lang=${LANG}"

# Resto del script permanece igual...
WEATHER=$(curl -fsS "$URL") || { echo '{"text":"","class":"error","tooltip":"Error al obtener datos del clima"}' | tr -d '\n'; exit 0; }

TEMP=$(jq -r '.main.temp // empty' <<<"$WEATHER")
ID=$(jq -r '.weather[0].id // 0' <<<"$WEATHER")
DESCRIPTION=$(jq -r '.weather[0].description // empty' <<<"$WEATHER")
HUMIDITY=$(jq -r '.main.humidity // empty' <<<"$WEATHER")
WIND_SPEED=$(jq -r '.wind.speed // empty' <<<"$WEATHER")
FEELS_LIKE=$(jq -r '.main.feels_like // empty' <<<"$WEATHER")

# Obtener datos de amanecer/atardecer
SUNRISE=$(jq -r '.sys.sunrise' <<<"$WEATHER")
SUNSET=$(jq -r '.sys.sunset' <<<"$WEATHER")
CURRENT_TS=$(date +%s)

# Determinar si es de día o noche
IS_DAYTIME=0
if (( CURRENT_TS > SUNRISE && CURRENT_TS < SUNSET )); then
  IS_DAYTIME=1
fi

if [[ -z "$TEMP" ]]; then
  echo '{"text":"","class":"error","tooltip":"Datos del clima no disponibles"}' | tr -d '\n'
  exit 0
fi

TEMP_INT=$(printf "%.0f" "$TEMP")

# Determinar icono y clase CSS basado en los códigos oficiales
if (( ID >= 200 && ID <= 232 )); then 
  # Thunderstorm (Grupo 2xx)
  ICON="⛈️"
  CLASS="thunderstorm"
elif (( ID >= 300 && ID <= 321 )); then 
  # Drizzle (Grupo 3xx) - Llovizna dia/noche
  if (( IS_DAYTIME )); then ICON="🌦️"; else ICON="🌧️"; fi
  CLASS="drizzle"
elif (( ID >= 500 && ID <= 504 )) || (( ID >= 520 && ID <= 531 )); then 
  # Rain (Grupo 5xx, excluyendo códigos especiales)
  ICON="🌧️"
  CLASS="rain"
elif (( ID == 511 )); then
  # Freezing rain (caso especial)
  ICON="❄️🌧️"
  CLASS="freezing-rain"
elif (( ID >= 600 && ID <= 622 )); then 
  # Snow (Grupo 6xx)
  ICON="❄️"
  CLASS="snow"
elif (( ID >= 701 && ID <= 781 )); then 
  # Atmosphere (Grupo 7xx)
  case $ID in
    701|711|721|731|741|751|761|762)
      ICON="🌫️"
      CLASS="fog"
      ;;
    771)
      ICON="🌬️"
      CLASS="squall"
      ;;
    781)
      ICON="🌪️"
      CLASS="tornado"
      ;;
  esac
elif (( ID == 800 )); then 
  # Clear (800) -- Dia y noche
  if (( IS_DAYTIME )); then ICON="☀️"; else ICON="🌙"; fi
  CLASS="clear" 
 
elif (( ID >= 801 && ID <= 804 )); then 
  # Nubes
  if (( IS_DAYTIME )); then
    case $ID in
      801) ICON="🌤️" ;;  # Pocas nubes
      802) ICON="⛅"  ;;  # Nubes dispersas
      *)   ICON="☁️"  ;;  # Muchas nubes
    esac
  else
    case $ID in
      801) ICON="🌙☁️" ;;  # Pocas nubes nocturnas
      802) ICON="🌌"   ;;  # Nubes dispersas nocturnas (uso de "vía láctea")
      *)   ICON="☁️"    ;;  # Muchas nubes (igual)
    esac
  fi
  CLASS="clouds"
else 
  ICON="❓"
  CLASS="unknown"
fi

TOOLTIP=$'<b>'${DESCRIPTION^}$'</b>\nTemperatura: '${TEMP_INT}${UNIT_SYMBOL}$' (Sensación: '${FEELS_LIKE%.*}${UNIT_SYMBOL}$')\nHumedad: '${HUMIDITY}$'%\nViento: '${WIND_SPEED}$' km/h'

# Generar JSON usando jq para manejar correctamente los caracteres especiales
jq -n \
  --arg text "${ICON} ${TEMP_INT}${UNIT_SYMBOL}" \
  --arg class "$CLASS" \
  --arg tooltip "$TOOLTIP" \
  '{text:$text, class:$class, tooltip:$tooltip}' | tr -d '\n'
