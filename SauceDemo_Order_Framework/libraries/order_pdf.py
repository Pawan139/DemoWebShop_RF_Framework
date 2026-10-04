from datetime import datetime as _datetime, timezone as _timezone
from pathlib import Path as _Path
from uuid import uuid4 as _uuid4

from pypdf import PdfReader as _PdfReader
from reportlab.lib import colors as _colors
from reportlab.lib.pagesizes import letter as _letter
from reportlab.lib.styles import getSampleStyleSheet as _get_sample_style_sheet
from reportlab.lib.units import inch as _inch
from reportlab.platypus import (
    Paragraph as _Paragraph,
    SimpleDocTemplate as _SimpleDocTemplate,
    Spacer as _Spacer,
    Table as _Table,
    TableStyle as _TableStyle,
)
from xml.sax.saxutils import escape as _escape


class OrderPdf:
    ROBOT_LIBRARY_SCOPE = "SUITE"

    def create_order_receipt_pdf(self, output_directory, order_details):
        output_path = _Path(output_directory).resolve()
        output_path.mkdir(parents=True, exist_ok=True)
        pdf_path = output_path / f"saucedemo_order_{_uuid4().hex[:10]}.pdf"
        receipt_id = _uuid4().hex[:12].upper()
        styles = _get_sample_style_sheet()
        body = styles["BodyText"]
        story = [
            _Paragraph("SauceDemo Order Receipt", styles["Title"]),
            _Spacer(1, 0.15 * _inch),
            _Paragraph(f"Receipt number: {receipt_id}", body),
            _Paragraph(
                f"Order completed: {_datetime.now(_timezone.utc).isoformat(timespec='seconds')}",
                body,
            ),
            _Paragraph("Order status: Complete", body),
            _Spacer(1, 0.2 * _inch),
            _Paragraph("Customer and delivery details", styles["Heading2"]),
        ]

        customer_rows = [
            ["First name", order_details["first_name"]],
            ["Last name", order_details["last_name"]],
            ["Postal code", order_details["postal_code"]],
        ]
        story.extend(self._table(customer_rows))
        story.extend(
            [
                Spacer(1, 0.15 * inch),
                _Paragraph("Items", styles["Heading2"]),
            ]
        )
        item_rows = [
            ["Product", "Price"],
            [order_details["backpack_name"], order_details["backpack_price"]],
            [order_details["tshirt_name"], order_details["tshirt_price"]],
        ]
        story.extend(self._table(item_rows, header=True))
        story.extend(
            [
                Spacer(1, 0.15 * inch),
                _Paragraph("Payment and totals", styles["Heading2"]),
            ]
        )
        totals_rows = [
            ["Payment", order_details["payment"]],
            ["Shipping", order_details["shipping"]],
            ["Subtotal", order_details["subtotal"]],
            ["Tax", order_details["tax"]],
            ["Order total", order_details["total"]],
        ]
        story.extend(self._table(totals_rows))
        _SimpleDocTemplate(
            str(pdf_path),
            pagesize=_letter,
            title="SauceDemo Order Receipt",
            author="SauceDemo Robot Framework test",
            rightMargin=0.6 * _inch,
            leftMargin=0.6 * _inch,
            topMargin=0.6 * _inch,
            bottomMargin=0.6 * _inch,
        ).build(story)
        return str(pdf_path)

    def read_pdf_text(self, pdf_path):
        path = _Path(pdf_path)
        if not path.is_file():
            raise FileNotFoundError(f"Order receipt PDF does not exist: {path}")
        reader = _PdfReader(str(path))
        if not reader.pages:
            raise ValueError(f"Order receipt PDF contains no pages: {path}")
        text = "\n".join(page.extract_text() or "" for page in reader.pages).strip()
        if not text:
            raise ValueError(f"Order receipt PDF contains no extractable text: {path}")
        return text

    @staticmethod
    def _table(rows, header=False):
        styles = [
            ("GRID", (0, 0), (-1, -1), 0.5, _colors.lightgrey),
            ("VALIGN", (0, 0), (-1, -1), "TOP"),
            ("LEFTPADDING", (0, 0), (-1, -1), 6),
            ("RIGHTPADDING", (0, 0), (-1, -1), 6),
            ("TOPPADDING", (0, 0), (-1, -1), 5),
            ("BOTTOMPADDING", (0, 0), (-1, -1), 5),
        ]
        if header:
            styles.extend(
                [
                    ("BACKGROUND", (0, 0), (-1, 0), _colors.HexColor("#e8edf3")),
                    ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ]
            )
        data = [
            [
                _Paragraph(_escape(str(cell)), _get_sample_style_sheet()["BodyText"])
                for cell in row
            ]
            for row in rows
        ]
        table = _Table(data, colWidths=[3.5 * _inch, 2.7 * _inch], hAlign="LEFT")
        table.setStyle(_TableStyle(styles))
        return [table]


def create_order_receipt_pdf(output_directory, order_details):
    return OrderPdf().create_order_receipt_pdf(output_directory, order_details)


def read_pdf_text(pdf_path):
    return OrderPdf().read_pdf_text(pdf_path)
