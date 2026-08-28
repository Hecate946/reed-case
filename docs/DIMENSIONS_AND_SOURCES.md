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
| Tray magnets | 6 x 2 mm disc |
| Hinge pin | 1.75 mm filament/rod |
| Reed envelope | 72 x 14 x 3.25 mm |

## Patented tray layout

One complete tray has two opposite platforms with five passages on each face,
so it carries ten Bb/Eb reeds. A humidity pack slides into the recess between
the platforms. Two complete trays stack magnetically for twenty reeds. The
Size-60 development preset uses seven passages on each face for 28 reeds.

Patent source: https://patents.google.com/patent/US12103755B2/en
