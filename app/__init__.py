from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_restful import Api
from flask_marshmallow import Marshmallow
from config import Config

app = Flask(__name__)
app.config.from_object(Config)

api = Api(app)

db = SQLAlchemy(app)
migrate = Migrate(app, db)

ma = Marshmallow(app)

from app import resources, models