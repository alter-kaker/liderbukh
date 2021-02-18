from app.models import Song, Author
from flask_marshmallow import Marshmallow

ma = Marshmallow()

class ShallowSongSchema(ma.SQLAlchemySchema):
    class Meta:
        model = Song
    id = ma.auto_field()
    name = ma.auto_field()


class ShallowAuthorSchema(ma.SQLAlchemySchema):
    class Meta:
        model = Author
    id = ma.auto_field()
    name = ma.auto_field()


class AuthorSchema(ma.SQLAlchemySchema):
    class Meta:
        model = Author
    id = ma.auto_field()
    name = ma.auto_field()
    songs = ma.List(ma.Nested(ShallowSongSchema))


class SongSchema(ma.SQLAlchemySchema):
    class Meta:
        model = Song
    id = ma.auto_field()
    name = ma.auto_field()
    author = ma.Nested(ShallowAuthorSchema)
    ly = ma.auto_field()
