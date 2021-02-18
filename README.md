# Liderbukh

An app to upload and convert music to beautiful lead sheets. This is the repository for the RESTful API server, implemented in Python + Flask + SQLAlchemy.

## Currently implemented:
- Database tables:
  - song: id, name, ly, id_author, id_composer
  - author: id, name
- API resources:
  - `GET /song/<int:id>`
  - `POST /song`
  - `GET /songs`
  - `POST /author`
  - `GET /author/<:id>`
  - `GET /authors`

## TODO:
- Set up a deployment with lilypond
- Generate score images
- Store and retrieve images on CDN (cloudinary)
- Store and retrieve lyrics
- Generate PDF leadsheets
- Store and retrieve leadsheets on CDN
- Implement user authentication and privileges
- Support multiple versions
- Support translations