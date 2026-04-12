import asyncio
import asyncpg
import os

async def run():
    conn = await asyncpg.connect(os.environ["DATABASE_URL"])
    print("Connected successfully!")
    with open("/app/database_setup.sql", "r") as f:
        sql = f.read()
    await conn.execute(sql)
    await conn.close()
    print("Migration complete!")

asyncio.run(run())
