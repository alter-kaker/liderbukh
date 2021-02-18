from app.resources import api
from app.models import db
from app.output_schema import ma

from flask import Flask
from config import Config
from flask_migrate import Migrate

app = Flask(__name__)
app.config.from_object(Config)

api.init_app(app)
db.init_app(app)
ma.init_app(app)

migrate = Migrate(app, db)
