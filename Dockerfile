
FROM python:3.13-slim

LABEL org.opencontainers.image.title="book-analysis" \
      org.opencontainers.image.description="Containerized Gutenberg book analysis using Python and MongoDB" \ 
      org.opencontainers.image.source="https://github.com/rsy1277/lab-09-containers"

COPY --from=ghcr.io/astral-sh/uv:0.12.18 /uv /bin/uv

RUN useradd --create-home app

WORKDIR /app

COPY pyproject.toml uv.lock ./

RUN uv sync --frozen --no-dev --no-install-project --no-cache

COPY src/ ./src/

ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONPATH="/app/src"

USER app

ENTRYPOINT ["python", "-m", "book_analysis.analyze"]

CMD ["--help"]

