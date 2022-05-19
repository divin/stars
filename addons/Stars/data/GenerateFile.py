import csv
import numpy as np

# Calculate RGB values from the color index, thanks @ paddyg
# (https://stackoverflow.com/questions/21977786/star-b-v-color-index-to-apparent-rgb-color)
def bv2rgb(bv : float) -> tuple:
  
  if bv < -0.4: bv = -0.4
  if bv > 2.0: bv = 2.0
  
  if bv >= -0.40 and bv < 0.00:
    t = (bv + 0.40) / (0.00 + 0.40)
    r = 0.61 + 0.11 * t + 0.1 * t * t
    g = 0.70 + 0.07 * t + 0.1 * t * t
    b = 1.0
  elif bv >= 0.00 and bv < 0.40:
    t = (bv - 0.00) / (0.40 - 0.00)
    r = 0.83 + (0.17 * t)
    g = 0.87 + (0.11 * t)
    b = 1.0
  elif bv >= 0.40 and bv < 1.60:
    t = (bv - 0.40) / (1.60 - 0.40)
    r = 1.0
    g = 0.98 - 0.16 * t
  else:
    t = (bv - 1.60) / (2.00 - 1.60)
    r = 1.0
    g = 0.82 - 0.5 * t * t
  
  if bv >= 0.40 and bv < 1.50:
    t = (bv - 0.40) / (1.50 - 0.40)
    b = 1.00 - 0.47 * t + 0.1 * t * t
  elif bv >= 1.50 and bv < 1.951:
    t = (bv - 1.50) / (1.94 - 1.50)
    b = 0.63 - 0.6 * t * t
  else:
    b = 0.0
  
  return (r, g, b)

# Path to file
# HYG-Database can be found here: https://github.com/astronexus/HYG-Database
path = "hygdata_v3.csv"

# Index of values
# id: 0 The database primary key.
# hip: 1 The star's ID in the Hipparcos catalog, if known.
# hd: 2 The star's ID in the Henry Draper catalog, if known.
# hr: 3 The star's ID in the Harvard Revised catalog, which is the same as its number in the Yale Bright Star Catalog.
# gl: 4 The star's ID in the third edition of the Gliese Catalog of Nearby Stars.
# bf: 5 The Bayer / Flamsteed designation, primarily from the Fifth Edition of the Yale Bright Star Catalog. This is a combination of the two designations. The Flamsteed number, if present, is given first; then a three-letter abbreviation for the Bayer Greek letter; the Bayer superscript number, if present; and finally, the three-letter constellation abbreviation. Thus Alpha Andromedae has the field value "21Alp And", and Kappa1 Sculptoris (no Flamsteed number) has "Kap1Scl".
# proper: 6 A common name for the star, such as "Barnard's Star" or "Sirius". I have taken these names primarily from the Hipparcos project's web site, which lists representative names for the 150 brightest stars and many of the 150 closest stars. I have added a few names to this list. Most of the additions are designations from catalogs mostly now forgotten (e.g., Lalande, Groombridge, and Gould ["G."]) except for certain nearby stars which are still best known by these designations.
# ra: 7 The star's right ascension, for epoch and equinox 2000.0.
# dec: 8 The star's declination, for epoch and equinox 2000.0.
# dist: 9 The star's distance in parsecs, the most common unit in astrometry. To convert parsecs to light years, multiply by 3.262. A value >= 100000 indicates missing or dubious (e.g., negative) parallax data in Hipparcos.
# pmra: 10 The star's proper motion in right ascension, in milliarcseconds per year.
# pmdec: 11 The star's proper motion in declination, in milliarcseconds per year.
# rv: 12 The star's radial velocity in km/sec, where known.
# mag: 13 The star's apparent visual magnitude.
# absmag: 14 The star's absolute visual magnitude (its apparent magnitude from a distance of 10 parsecs).
# spect: 15 The star's spectral type, if known.
# ci: 16 The star's color index (blue magnitude - visual magnitude), where known.
# x,y,z: 17, 18, 19 The Cartesian coordinates of the star, in a system based on the equatorial coordinates as seen from Earth. +X is in the direction of the vernal equinox (at epoch 2000), +Z towards the north celestial pole, and +Y in the direction of R.A. 6 hours, declination 0 degrees.
# vx,vy,vz: 20, 21, 22 The Cartesian velocity components of the star, in the same coordinate system described immediately above. They are determined from the proper motion and the radial velocity (when known). The velocity unit is parsecs per year; these are small values (around 1 millionth of a parsec per year), but they enormously simplify calculations using parsecs as base units for celestial mapping.
# rarad, decrad, pmrarad, pmdecrad: The positions in radians, and proper motions in radians per year.
# bayer: The Bayer designation as a distinct value
# flam: The Flamsteed number as a distinct value
# con: The standard constellation abbreviation
# comp, comp_primary, base: Identifies a star in a multiple star system. comp = ID of companion star, comp_primary = ID of primary star for this component, and base = catalog ID or name for this multi-star system. Currently only used for Gliese stars.
# lum: Star's luminosity as a multiple of Solar luminosity.
# var: Star's standard variable star designation, when known.
# var_min, var_max: Star's approximate magnitude range, for variables. This value is based on the Hp magnitudes for the range in the original Hipparcos catalog, adjusted to the V magnitude scale to match the "mag" field.

index_proper = 6
index_ra = 7
index_dec = 8
index_mag = 13
index_ci = 16
index_x = 17
index_y = 18
index_z = 19

print("Read File...")

# Read file
data = []
with open(path, "r") as file:
	rows = csv.reader(file)
	next(rows) # skip header
	next(rows) # skip sun
	
	for row in rows:

		# Get apparent magnitude
		apparent_magnitude = float(row[index_mag])

		# Check if star is bright enough to be visible with the naked eye
		if apparent_magnitude > 6.5:
			continue

		# Get other values
		name = row[index_proper]
		right_ascension = float(row[index_ra])
		declination = float(row[index_dec])
		bv = float(row[index_ci]) if row[index_ci] != "" else 0.0
		x = float(row[index_x])
		y = float(row[index_y])
		z = float(row[index_z])


		
		# Calculate longitude & latitude
		latitude = np.deg2rad(declination)
		longitude = np.deg2rad((right_ascension * 360.0) / 24.0 - 180.0)

		# Calculate RGB values from the color index
		r, g, b = bv2rgb(bv)
		
		values = [name, apparent_magnitude, latitude, longitude, x, y, z, r, g, b]
		data.append(values)

print("Write File...")

# Write Data
header = ["name", "apparent magnitude", "latitude", "longitude", "x", "y", "z", "r", "g", "b"]
with open("Stars.csv", "w") as file:
	writer = csv.writer(file, delimiter = ",")
	writer.writerow(header)
	writer.writerows(data)

print("Done!")