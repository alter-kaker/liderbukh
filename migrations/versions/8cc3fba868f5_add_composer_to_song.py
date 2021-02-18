"""add composer to song

Revision ID: 8cc3fba868f5
Revises: 77c2f726affd
Create Date: 2021-02-18 10:52:41.557611

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '8cc3fba868f5'
down_revision = '77c2f726affd'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('song', sa.Column('id_composer', sa.Integer(), nullable=True))
    op.create_foreign_key(None, 'song', 'author', ['id_composer'], ['id'])
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_constraint(None, 'song', type_='foreignkey')
    op.drop_column('song', 'id_composer')
    # ### end Alembic commands ###