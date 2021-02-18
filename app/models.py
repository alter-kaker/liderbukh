from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


class Author(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(), index=True,
                     unique=True)

    def __repr__(self):
        return '<Author {}>'.format(self.name)


class Song(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(), unique=True, nullable=False)
    ly = db.Column(db.String())
    id_author = db.Column(db.ForeignKey('author.id'))
    id_composer = db.Column(db.ForeignKey('author.id'))
    author = db.relationship('Author', foreign_keys=id_author)
    composer = db.relationship('Author', foreign_keys=id_composer)

    def __init__(self, **args):
        super().__init__(**args)
        # process input into images etc

    def __repr__(self):
        return '<Song {} by {}>'.format(self.name, self.author.name)
