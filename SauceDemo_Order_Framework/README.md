# SauceDemo Order Framework

This is an independent Robot Framework Browser Library project. It logs in with
SauceDemo's `standard_user`, adds the Backpack and red Test.allTheThings! shirt,
checks out, validates the displayed order, completes it, creates a printable PDF
receipt, verifies and prints the PDF text, and logs out.

SauceDemo does not provide a "Generate PDF Order" or PDF-download control. The
framework therefore creates a local PDF receipt from the checkout information
and order details verified on the site. The PDF is saved under `downloads/` in
the Robot output directory and its extracted text is printed in the console.
Screenshots for browser actions are saved under `screenshots/` in the same
output directory.

## Setup

```powershell
python -m pip install -r requirements.txt
rfbrowser init
```

Run from this directory:

```powershell
robot --outputdir results tests/saucedemo_order.robot
```

The test uses the sample checkout data in `data/saucedemo_data.py`. Change those
values to use different shipping details.
