---
id: account
title: Conta
---

É possível acessar a conta (NeoSwift/Clients/Account.swift) com os seguintes parâmetros:

- WIF
```
let account = Account(wif: "L33xET8EkayBJzwSZ9vRi4TYxeiatq8quUF3x1cnhG9jVqTcEjsm")
```

- Private key
```
let account = Account(privateKey: "ae012da38dfba592d28859cbad4cf6276e75cf0c3795a0f1611531a754f772c7")
```

- Encrypted Private Key e passphrase
```
let account = Account(encryptedPrivateKey: "6PYSEybC8LEzN98WjghY5SWZ1ZVQH992y9G69wCReb567NwgGj1tPF3jXB", passphrase: "neoswifttest")
```

No modo debug é adicionado algumas configurações na compilação que torna o método scrypt().scrypt muito lento (mais de 2 minutos), em modo release não terá problema de performance.
Para rodar no modo release o seu aplicativo, edite o "esquema" do projeto e mude a configuração de build do debug para release.

- Ou poderá criar uma conta nova
```
let account = Account()
```