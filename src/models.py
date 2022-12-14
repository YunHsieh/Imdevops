import datetime
import databases
import sqlalchemy
import ormar
from environments import DATABASE_URI


class DateTimeFieldsMixins:
    created_at: datetime = ormar.DateTime(default=datetime.datetime.utcnow())
    updated_at: datetime = ormar.DateTime(default=datetime.datetime.utcnow(), onupdate=datetime.datetime.utcnow())

database = databases.Database(DATABASE_URI)
metadata = sqlalchemy.MetaData()


class Notification(ormar.Model, DateTimeFieldsMixins):
    class Meta:
        database = database
        metadata = metadata

    id: int = ormar.Integer(primary_key=True, autoincrement=True)
    name: str = ormar.String(max_length=256)
    state: int = ormar.Integer()
    responsed_text: str = ormar.Text(nullable=True)


async def with_connect(function, arg):
    async with database:
        await function(**arg)
