import asyncio
import asyncpg
import os

async def run():
    conn = await asyncpg.connect(os.environ["DATABASE_URL"])
    print("Connected successfully!")
    with open("/app/database_setup.sql", "r") as f:
        lines = f.readlines()
    # Filter out psql meta-commands (lines starting with \)
    sql_lines = [l for l in lines if not l.strip().startswith("\\")]
    sql = "".join(sql_lines)
    await conn.execute(sql)
    await conn.close()
    print("Migration complete!")

asyncio.run(run())
