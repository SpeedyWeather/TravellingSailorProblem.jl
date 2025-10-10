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
    (139.6917, 35.6895),    # Tokyo, Japan
    (7.4500, 43.7102),      # Nice, France
    (174.7633, -36.8485),   # Auckland, New Zealand
    (-99.1332, 19.4326),    # Mexico City, Mexico
    (12.4964, 41.9028),     # Rome, Italy
    (-3.7038, 40.4168),     # Madrid, Spain
    (13.4050, 52.5200),     # Berlin, Germany
    (2.2950, 48.8588),      # Paris, France
    (121.7732, 25.0328),    # Taipei, Taiwan
    (-46.6333, -23.5505),   # São Paulo, Brazil
    (99.0765, 19.9136),     # Chiang Mai, Thailand
    (121.5654, 25.0330),    # Taipei, Taiwan
    (151.2153, -33.8600),   # Sydney, Australia
    (28.6139, 77.2090),     # New Delhi, India
    (77.2090, 28.6139),     # New Delhi, India
    (3.1390, 101.6869),     # Kuala Lumpur, Malaysia
    (144.9631, -37.8136),   # Melbourne, Australia
    (0.1276, 51.5074),      # London, UK
    (40.7306, -73.9352),    # New York, USA
    (-74.0119, 40.7053),    # New York, USA
    (19.4326, -99.1332),    # Mexico City, Mexico
    (-0.1180, 51.5090),     # London, UK
    (151.2153, -33.8600),   # Sydney, Australia
    (116.4074, 39.9042),    # Beijing, China
    (151.2093, -33.8688),   # Sydney, Australia
    (12.4964, 41.9028),     # Rome, Italy
    (1.290270, 103.851959), # Singapore
    (106.6456, -6.2088),    # Jakarta, Indonesia
    (121.5676, 25.0330),    # Taipei, Taiwan
    (-74.0060, 40.7128),    # New York, USA
    (139.6917, 35.6895),    # Tokyo, Japan
    (13.404954, 52.520006), # Berlin, Germany
    (2.3522, 48.8566),      # Paris, France
    (-79.3832, 43.6532),    # Toronto, Canada
    (31.5497, 74.3436),     # Lahore, Pakistan
    (-46.6333, -23.5505),   # São Paulo, Brazil
    (37.7749, -122.4194),   # San Francisco, USA
    (52.3676, 4.9041),      # Amsterdam, Netherlands
    (40.7128, -74.0060),    # New York, USA
    (-34.6037, -58.4438),   # Buenos Aires, Argentina
    (104.9903, 15.8700),    # Bangkok, Thailand
    (38.7167, 9.25),        # Addis Ababa, Ethiopia
    (37.7749, -122.4194),   # San Francisco, USA
    (24.7136, 46.6753),     # Riyadh, Saudi Arabia
    (80.2547, 13.0827),     # Chennai, India
    (2.3522, 48.8566),      # Paris, France
    (-3.7038, 40.4168),     # Madrid, Spain
    (13.4050, 52.5200),     # Berlin, Germany
    (18.4241, -33.9249),    # Cape Town, South Africa
    (22.5726, 88.3639),     # Kolkata, India
    (106.6957, 10.762622),  # Ho Chi Minh City, Vietnam
    (36.7783, -119.4179),   # Fresno, USA
    (55.7558, 37.6173),     # Moscow, Russia
    (-0.1278, 51.5074),     # London, UK
    (31.5497, 74.3436),     # Lahore, Pakistan
    (50.4501, 30.5087),     # Kiev, Ukraine
    (8.9833, 38.7469),      # Addis Ababa, Ethiopia
    (41.9028, 12.4964),     # Rome, Italy
    (52.3792, 4.9008),      # Amsterdam, Netherlands
    (-58.4438, -34.6037),   # Buenos Aires, Argentina
    (77.2090, 28.6139),     # New Delhi, India
    (52.3676, 4.9041),      # Amsterdam, Netherlands
    (48.8566, 2.3522),      # Paris, France
    (40.7306, -73.9352),    # New York, USA
    (151.2153, -33.8688),   # Sydney, Australia
    (19.0760, 72.8777),     # Mumbai, India
    (-74.0059, 40.7128),    # New York, USA
    (103.8198, 1.3521),     # Singapore
    (12.4964, 41.9028),     # Rome, Italy
    (2.3522, 48.8566),      # Paris, France
    (5.6781, 52.1214)       # Banjul, Gambia
]

using Random
const SEED = 1234
const RNG = Random.Xoshiro(SEED)

shuffle!(RNG, NAMES)
shuffle!(RNG, CITIES)