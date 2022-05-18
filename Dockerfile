FROM python:3-alpine

COPY app.py requirements.txt ./

RUN pip install -r requirements.txt

CMD ["python", "app.py"]
