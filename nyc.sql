CREATE TABLE boroughs (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE neighborhoods (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  borough_id INTEGER,

  FOREIGN KEY(borough_id) REFERENCES boroughs(id)
);

CREATE TABLE sights (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  neighborhood_id INTEGER,

  FOREIGN KEY(neighborhood_id) REFERENCES neighborhoods(id)
);

INSERT INTO
  boroughs (id, name)
VALUES
  (1, "Bronx"),
  (2, "Brooklyn"),
  (3, "Manhattan"),
  (4, "Queens"),
  (5, "Staten Island");

INSERT INTO
  neighborhoods (id, name, borough_id)
VALUES
  (1, "Lower Manhattan", 3),
  (2, "East Village", 3),
  (3, "Battery Park", 3),
  (4, "SoHo", 3),
  (5, "Wall Street", 3),
  (6, "Midtown", 3),
  (7, "Garment District", 3),
  (8, "Hell's Kitchen", 3),
  (9, "Upper East Side", 3),
  (10, "Upper West Side", 3),
  (11, "Times Square", 3),
  (12, "Upper Manhattan", 3),
  (13, "Washington Heights", 3),
  (14, "Greenpoint", 2),
  (15, "Williamsburg", 2),
  (16, "Bedford-Stuyvesant", 2),
  (17, "Crown Heights", 2),
  (18, "Flatbush", 2),
  (19, "Coney Island", 2),
  (20, "Midwood", 2),
  (21, "Bensonhurst", 2),
  (22, "Bay Ridge", 2),
  (23, "Borough Park", 2),
  (24, "Park Slope", 2),
  (25, "Brownsville", 2),
  (26, "Canarsie", 2),
  (27, "Sheepshead Bay", 2),
  (28, "Bushwick", 2),
  (29, "Canarsie", 2),
  (30, "Riverdale", 1),
  (31, "Kingsbridge", 2),
  (32, "Morrisania", 2),
  (33, "Morris Park", 2),
  (34, "Pelham Bay", 2),
  (35, "Astoria", 4),
  (36, "Flushing", 4),
  (37, "Jackson Heights", 4),
  (38, "Long Island City", 4),
  (39, "Forest Hills", 4),
  (40, "Jamaica", 4),
  (41, "Elmhurst", 4),
  (42, "Little Neck", 4),
  (43, "Whitestone", 4),
  (44, "St. George", 5),
  (45, "Great Kills", 5),
  (46, "Stapleton", 5),
  (47, "West New Brighton", 5),
  (48, "Todt Hill", 5),
  (49, "Port Richmond", 5),
  (50, "Eltingville", 5),
  (51, "New Dorp", 5),
  (52, "Great Kills", 5),
  (53, "Chelsea", 3),
  (54, "Mott Haven", 1),
  (55, "Woodlawn", 1),
  (56, "Throggs Neck", 1),
  (57, "Belmont", 1),
  (58, "Concourse", 1),
  (59, "West Brighton", 5),
  (60, "Hunts Point", 1);

INSERT INTO
  sights (id, name, neighborhood_id)
VALUES
  (1, "Empire State Building", 6),
  (2, "Times Square", 11),
  (3, "High Line", 53),
  (4, "Grand Central Terminal", 6),
  (5, "Museum of Modern Art", 6),
  (6, "Bronx Zoo", 57),
  (7, "Brooklyn Botanic Garden", 24),
  (8, "Coney Island", 19),
  (9, "Prospect Park", 24),
  (10, "Yankee Stadium", 58),
  (11, "New York Stock Exchange", 5),
  (12, "National September 11 Memorial & Museum", 1);
