from app import api
from flask_restful import Resource

class HelloWorld(Resource):
  def get(self):
    return {'hello': 'world'}

api.add_resource(HelloWorld, '/')