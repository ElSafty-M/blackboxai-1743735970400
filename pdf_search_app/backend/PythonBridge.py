from PySide6.QtCore import QObject, Slot, Signal
import os
from whoosh.index import create_in, exists_in, open_dir
from whoosh.fields import Schema, TEXT, ID, STORED
from whoosh.analysis import RegexTokenizer, LowercaseFilter
from whoosh.qparser import QueryParser
from PyPDF2 import PdfReader
import pytesseract
from PIL import Image
import fitz  # PyMuPDF

class PythonBridge(QObject):
    searchResultsReady = Signal(list)  # Signal to send search results to QML

    def __init__(self):
        super().__init__()
        self.index_dir = "whoosh_index"
        self.setup_index()
        self.regex_mode = False
        self.arabic_only = False

    def setup_index(self):
        # Create schema with custom analyzer for Arabic support
        schema = Schema(
            path=ID(stored=True),
            title=TEXT(stored=True),
            content=TEXT(analyzer=self.create_analyzer()),
            tags=TEXT(stored=True)
        )

        if not os.path.exists(self.index_dir):
            os.mkdir(self.index_dir)
            self.ix = create_in(self.index_dir, schema)
        else:
            self.ix = open_dir(self.index_dir)

    def create_analyzer(self):
        # Custom analyzer for Arabic text
        return RegexTokenizer() | LowercaseFilter()

    @Slot(str)
    def add_pdf(self, file_path):
        try:
            text = ""
            metadata = {}
            
            # Extract text using PyMuPDF
            with fitz.open(file_path) as doc:
                metadata = doc.metadata
                for page in doc:
                    if page.get_text("text"):  # Text-based PDF
                        text += page.get_text("text")
                    else:  # Scanned PDF - use OCR
                        pix = page.get_pixmap()
                        img = Image.frombytes("RGB", [pix.width, pix.height], pix.samples)
                        text += pytesseract.image_to_string(img, lang='ara+eng')

            # Add to search index
            writer = self.ix.writer()
            writer.add_document(
                path=file_path,
                title=metadata.get('title', os.path.basename(file_path)),
                content=text,
                tags=""
            )
            writer.commit()
            return True
        except Exception as e:
            print(f"Error processing PDF: {str(e)}")
            return False

    @Slot(str)
    def search(self, query_text):
        try:
            with self.ix.searcher() as searcher:
                # Create query parser with the appropriate field
                qp = QueryParser("content", self.ix.schema)
                
                if self.regex_mode:
                    query = qp.parse(f"content:/{query_text}/")
                else:
                    query = qp.parse(query_text)
                
                results = searcher.search(query, limit=20)
                self.searchResultsReady.emit([hit['path'] for hit in results])
        except Exception as e:
            print(f"Search error: {str(e)}")
            self.searchResultsReady.emit([])

    @Slot(bool)
    def setRegexMode(self, enabled):
        self.regex_mode = enabled

    @Slot(bool)
    def setArabicOnly(self, enabled):
        self.arabic_only = enabled