from app import ma
from app.models import Song, Author


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
