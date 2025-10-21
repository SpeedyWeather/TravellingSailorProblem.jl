const NAMES = [
  :Ana, :Babu, :Carla, :Diego, :Elias, :Felipe, :Gael, :Haruko, :Isla, :Jose,
  :Karim, :Lola, :Maeve, :Noah, :Omar, :Priya, :Quirin, :Rasmus, :Saanvi,
  :Tomas, :Uma, :Vera, :Walter, :Xun, :Yuki, :Zara,
]

const MAX_NAME_LENGTH = maximum(length.(string.(NAMES)))

const PLACES = [
  (15.6, 78.2),       # Longyearbyen, Svalbard
  (140.7, 69.3),      # Magadan, Russia
  (-51.7, 64.2),      # Nuuk, Greenland
  (76.9, 43.2),       # Almaty, Kazakhstan
  (-97.1, 49.9),      # Winnipeg, Canada
  (-96.7, 17.1),      # Oaxaca, Mexico
  (-7.6, 33.6),       # Casablanca, Morocco
  (106.8, 10.8),      # Ho Chi Minh City, Vietnam
  (-74.1, 4.7),       # Bogotá, Colombia
  (-157.8, 21.3),     # Honolulu, Hawaii
  (15.3, 4.4),        # Bangui, Central African Republic
  (115.9, -31.9),     # Perth, Australia
  (-47.9, -15.8),     # Brasília, Brazil
  (151.2, -33.9),     # Sydney, Australia
  (-5.9, -15.9),      # Saint Helena
  (115.0, -8.7),      # Bali, Indonesia (adjusted for better spacing)
  (-70.7, -53.2),     # Punta Arenas, Chile
  (85.3, 27.7),       # Kathmandu, Nepal
  (-1.3, 51.8),       # Oxford, UK
  (-61.5, 10.5),      # Port of Spain, Trinidad
  (121.0, 14.6),      # Manila, Philippines
  (139.7, 35.7),      # Tokyo, Japan
  (73.5, -4.6),       # Seychelles
  (-169.9, -21.2),    # Alofi, Niue
  (18.5, -33.9),      # Cape Town, South Africa
  (166.7, -77.8),     # McMurdo Station, Antarctica
]

using Random
const SEED = 1234           # change this for a new challenge
const RNG = Random.Xoshiro(SEED)

shuffle!(RNG, NAMES)
shuffle!(RNG, PLACES)