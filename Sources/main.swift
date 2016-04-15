let d = HMACHash().hmac(.SHA256, key: "hoge", data: "This is secret key")
print(d.description)