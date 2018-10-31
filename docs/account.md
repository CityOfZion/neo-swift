---
id: account
title: Account
---

To open your account (NeoSwift/Clients/Account.swift) you can use:

- WIF
```
let account = Account(wif: "L33xET8EkayBJzwSZ9vRi4TYxeiatq8quUF3x1cnhG9jVqTcEjsm")
```

- Private key
```
let account = Account(privateKey: "ae012da38dfba592d28859cbad4cf6276e75cf0c3795a0f1611531a754f772c7")
```

- Encrypted Private Key and passphrase
```
let account = Account(encryptedPrivateKey: "6PYSEybC8LEzN98WjghY5SWZ1ZVQH992y9G69wCReb567NwgGj1tPF3jXB", passphrase: "neoswifttest")
```

On debug mode the compiler add some configuration and the method scrypt().scrypt become very slow (more than two minutes), on release mode the performance is normal.
To launch your app on release mode, edit project scheme, changing build configuration from 'debug' to 'release'.

- You can create a new account with:
```
let account = Account()
```