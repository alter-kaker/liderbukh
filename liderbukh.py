from app import app, db
from app.models import Author, Song


@app.shell_context_processor
def make_shell_context():
    return {'db': db, 'Author': Author, 'Song': Song}


if __name__ == '__main__':
    app.run(debug=True)
