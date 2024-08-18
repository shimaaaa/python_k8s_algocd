FROM python:3.12-bookworm

WORKDIR /usr/src/apps

# install package
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    && apt-get clean

# upgrade pip
RUN pip install --upgrade pip

# install poetry
ENV POETRY_HOME=/opt/poetry\
    POETRY_VERSION=1.8.3\
    PATH=/opt/poetry/bin:${PATH}

RUN curl -sSL https://install.python-poetry.org | python -

# setting poetry
RUN poetry config virtualenvs.create false

# copy files
COPY ./apps /usr/src/apps/

# install library
RUN poetry export -f requirements.txt --output requirements.txt\
    && pip install -r requirements.txt\
    && rm requirements.txt

WORKDIR /usr/src/apps
EXPOSE 8000
CMD [ "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000" ]
