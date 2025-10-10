const NAMES = [
  :Aaliyah, :Aarav, :Abel, :Adama, :Akira, :Alana, :Alejandro, :Amara, :Amir, :Ana,
  :Anjali, :Asher, :Atticus, :Aurora, :Ayodele, :Bianca, :Bodhi, :Caden, :Callum, :Carmen,
  :Celeste, :Chike, :Clara, :Daiki, :Daniel, :Davina, :Diego, :Dimitri, :Dinesh, :Elena,
  :Eli, :Elias, :Emil, :Eamon, :Enzo, :Esme, :Farah, :Felipe, :Fiona, :Freya,
  :Gabriel, :Gael, :Giovanni, :Hana, :Hassan, :Hector, :Helene, :Hiroshi, :Ingrid, :Imani,
  :Imran, :Isaac, :Isla, :Ivana, :Jalen, :Jamal, :Jasmine, :Joaquin, :Jose, :Kai,
  :Karim, :Kiana, :Kiara, :Leila, :Luca, :Lila, :Liam, :Linh, :Lola, :Lourdes,
  :Luca, :Maeve, :Malika, :Mateo, :Maya, :Nia, :Nadia, :Noah, :Niko, :Omar,
  :Olivia, :Omar, :Oriana, :Oscar, :Priya, :Rafael, :Raj, :Rania, :Rasmus, :Saanvi,
  :Santiago, :Sophia, :Tariq, :Tomas, :Uma, :Valentina, :Viktor, :Yasmin, :Yuki, :Zara,
]

const CITIES = [
    (-74.0060, 40.7128),    # New York, USA
    (-0.1278, 51.5074),     # London, UK
    (2.3522, 48.8566),      # Paris, France
    (139.6917, 35.6895),    # Tokyo, Japan
    (116.4074, 39.9042),    # Beijing, China
    (-73.5673, 45.5017),    # Montreal, Canada
    (151.2093, -33.8688),   # Sydney, Australia
    (-58.4438, -34.6037),   # Buenos Aires, Argentina
    (7.4500, 43.7102),      # Nice, France
    (174.7633, -36.8485),   # Auckland, New Zealand
    (-99.1332, 19.4326),    # Mexico City, Mexico
    (12.4964, 41.9028),     # Rome, Italy
    (-3.7038, 40.4168),     # Madrid, Spain
    (13.4050, 52.5200),     # Berlin, Germany
    (121.5654, 25.0330),    # Taipei, Taiwan
    (-46.6333, -23.5505),   # São Paulo, Brazil
    (99.0765, 19.9136),     # Chiang Mai, Thailand
    (77.2090, 28.6139),     # New Delhi, India
    (3.1390, 101.6869),     # Kuala Lumpur, Malaysia
    (144.9631, -37.8136),   # Melbourne, Australia
    (106.6456, -6.2088),    # Jakarta, Indonesia
    (-79.3832, 43.6532),    # Toronto, Canada
    (74.3436, 31.5497),     # Lahore, Pakistan
    (37.7749, -122.4194),   # San Francisco, USA
    (4.9041, 52.3676),      # Amsterdam, Netherlands
    (104.9903, 15.8700),    # Bangkok, Thailand
    (38.7167, 9.25),        # Addis Ababa, Ethiopia
    (24.7136, 46.6753),     # Riyadh, Saudi Arabia
    (80.2547, 13.0827),     # Chennai, India
    (18.4241, -33.9249),    # Cape Town, South Africa
    (88.3639, 22.5726),     # Kolkata, India
    (106.6957, 10.762622),  # Ho Chi Minh City, Vietnam
    (36.7783, -119.4179),   # Fresno, USA
    (37.6173, 55.7558),     # Moscow, Russia
    (30.5087, 50.4501),     # Kiev, Ukraine
    (72.8777, 19.0760),     # Mumbai, India
    (103.8198, 1.3521),     # Singapore
    (11.9754, 57.7089),     # Gothenburg, Sweden
    (21.0122, 52.2297),     # Warsaw, Poland
    (16.3738, 48.2082),     # Vienna, Austria
    (4.9036, 52.3676),      # The Hague, Netherlands
    (8.2275, 46.8182),      # Zurich, Switzerland
    (10.7522, 59.9139),     # Oslo, Norway
    (12.5683, 55.6761),     # Copenhagen, Denmark
    (24.9384, 60.1699),     # Helsinki, Finland
    (-6.2603, 53.3498),     # Dublin, Ireland
    (139.7514, 35.685),     # Shibuya, Japan
    (126.9780, 37.5665),    # Seoul, South Korea
    (127.7669, 26.2041),    # Okinawa, Japan
    (114.1694, 22.3193),    # Hong Kong
    (100.5018, 13.7563),    # Bangkok Central, Thailand
    (78.4867, 17.3850),     # Hyderabad, India
    (88.3639, 22.5726),     # Calcutta, India
    (2.1734, 41.3851),      # Barcelona, Spain
    (9.1900, 45.4642),      # Milan, Italy
    (7.6869, 45.0703),      # Turin, Italy
    (11.2558, 43.7696),     # Florence, Italy
    (14.2681, 40.8518),     # Naples, Italy
    (-8.2245, 53.4129),     # Cork, Ireland
    (4.4777, 51.9244),      # Rotterdam, Netherlands
    (3.2174, 51.2194),      # Bruges, Belgium
    (4.3517, 50.8503),      # Brussels, Belgium
    (6.1432, 49.6116),      # Luxembourg City, Luxembourg
    (7.4474, 46.9480),      # Bern, Switzerland
    (8.5417, 47.3769),      # Zurich Central, Switzerland
    (-1.5491, 53.8008),     # Leeds, UK
    (-2.2426, 53.4808),     # Manchester, UK
    (-3.1883, 55.9533),     # Edinburgh, UK
    (28.9784, 41.0082),     # Istanbul, Turkey
    (32.8597, 39.9334),     # Ankara, Turkey
    (35.2433, 38.9637),     # Kayseri, Turkey
    (29.0610, 41.0053),     # Kadikoy, Turkey
    (23.7275, 37.9755),     # Athens, Greece
    (24.6382, 40.6401),     # Thessaloniki, Greece
]

using Random
const SEED = 1234
const RNG = Random.Xoshiro(SEED)

shuffle!(RNG, NAMES)
shuffle!(RNG, CITIES)