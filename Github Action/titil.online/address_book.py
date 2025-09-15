
from flask import Flask, request, jsonify

app = Flask(__name__)

# لیست مخاطبین به صورت موقت در حافظه
contacts = []

# صفحه اصلی
@app.route('/')
def home():
    return "Welcome to Address Book API! this is my first change in code"

# اضافه کردن مخاطب
@app.route('/add', methods=['POST'])
def add_contact():
    data = request.json
    contacts.append(data)
    return jsonify({"message": "Contact added!", "contacts": contacts})

# نمایش همه مخاطبین
@app.route('/contacts', methods=['GET'])
def get_contacts():
    return jsonify(contacts)

# جستجوی مخاطب با نام
@app.route('/search/<name>', methods=['GET'])
def search_contact(name):
    result = [c for c in contacts if c.get("name") == name]
    return jsonify(result)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
