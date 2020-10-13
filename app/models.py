from app import db


class Author(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(), index=True,
                     unique=True)

    songs = db.relationship('Song', backref='author', lazy='dynamic')

    def __repr__(self):
        return '<Author {} {}>'.format(self.id, self.name)

    def json(self):
        return {'name': self.name, 'songs': [s.name for s in self.songs.all()]}


class Song(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(), unique=True, nullable=False)
    id_author = db.Column(db.ForeignKey('author.id'), nullable=False)

    def __repr__(self):
        return '<Song {} by {}>'.format(self.name, self.author.name)

    def json(self):
        return {'name': self.name, 'author': self.author.name}
