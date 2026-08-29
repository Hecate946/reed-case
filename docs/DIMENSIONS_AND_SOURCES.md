# Dimensions and source boundary

## Publicly verified Behn specifications

The default preset uses the public Bb/Eb Clarinet Premium 20 exterior listing:

| Property | Public value used |
|---|---:|
| Closed body height | 1.50 in / 38.1 mm |
| Closed body width | 4.00 in / 101.6 mm |
| Closed body depth | 4.00 in / 101.6 mm |
| Capacity | 20 Bb/Eb clarinet reeds |
| Tray arrangement | Two magnetically attached 10-reed tray groups |
| Construction material | PLA |
| Seal | Rubber gasket, airtight construction |
| Reed support | Perforated tray; reeds elevated on rails |
| Humidity | 72% two-way Boveda, one per tray group |

In this implementation the hinge is kept inside that width/depth envelope by
shortening the rounded shell body at the rear. The removable latch clip and
hinge-pin head are service hardware and can protrude beyond the envelope.

Sources checked August 28, 2026:

- Behn Single Reed Cases product page:
  https://www.clarinetmouthpiece.com/product-page/behn-reed-case
- Clarinet World Behn reed case collection:
  https://clarinetworld.com/collections/behn-reed-cases
- Independent feature description:
  https://www.joffewoodwinds.com/articles/equipment-reviews-iv/

## Boveda face dimensions

| Pack | Face dimensions encoded | Intended preset |
|---|---:|---|
| Size 8 | 69.85 x 63.50 mm | `behn_premium20` |
| Size 60 | 133.35 x 88.90 mm | `size60_studio` |

The Size 60 face dimensions are from Boveda's product listing. Pack thickness
varies with hydration and is therefore a design allowance, not a guaranteed
manufacturer dimension. Measure your actual pack and update `boveda_h`.

- Size 8: https://store.bovedainc.com/products/boveda-for-cigars-size-8
- Size 60: https://store.bovedainc.com/products/boveda-for-cigars-size-60

### Prototype tray opening and retention

For `behn_premium20`, the current Size 8 Boveda opening target is **71.85 mm
wide x 5.10 mm high**. The face dimensions are verified above; the encoded
4.50 mm pack thickness is only an engineering allowance and must be checked
against a real hydrated pack.

Both silicone retention grooves are deliberately at the same height in the
first prototype and are sized around 2.0 mm round silicone. Magnet polarity is
not encoded in the geometry: both tray faces use the same 4.20 x 2.15 mm
pocket, so the hardware scheme can be chosen after the tray fit is proven.

## Original engineering assumptions

Behn does not publish millimeter dimensions for its wall thickness, rail
profile, gasket groove, hinge, tolerances, magnets, or tray components. Patent
US12103755B2 does, however, disclose the tray's component relationships and
functional geometry; the code follows those disclosed relationships.

The following are independent starting values and should be prototyped:

| Parameter | Starting value |
|---|---:|
| Shell/floor thickness | 2.4 mm |
| Printer clearance | 0.25 mm |
| Silicone gasket cord | 2.0 mm |
| Gasket groove | 2.35 mm wide x 1.30 mm deep |
| Gasket compression target | 25% |
| Tray hardware pocket | 4 x 2 mm nominal disc; 4.20 x 2.15 mm straight pocket |
| Hinge pin | 1.75 mm filament/rod |
| Reed envelope | 70.5 x 13.4 x 3.30 mm |

## Reference photographs

Four photographs of the retail tray and of a printed copy were used as a
visual reference. They carry no scale, so they were used to fix topology and
proportion only, never absolute dimensions. The departures they drove, and the
config flags that revert each one, are listed in `PHOTO_MATCH.md`.

## Patented tray layout

One complete tray has two opposite platforms with five passages on each face,
so it carries ten Bb/Eb reeds. A humidity pack slides into the recess between
the platforms. Two complete trays stack magnetically for twenty reeds. The
Size-60 development preset uses seven passages on each face for 28 reeds.

Patent source: https://patents.google.com/patent/US12103755B2/en
