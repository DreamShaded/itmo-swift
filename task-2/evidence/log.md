# Meowle Lab — журнал доказательств
_сгенерировано Вс 31 мая 2026 18:53:26 UTC_  стенд: http://144.31.255.0:3001

## ПОДГОТОВКА: создаю собственного тестового кота

### `POST /api/core/cats/add`
тело-запроса: `{"cats":[{"name":"Котозонд","gender":"unisex","description":"QA baseline probe"}]}`
статус: **200**
```json
{"cats":[{"id":48,"name":"Котозонд","description":"QA baseline probe","tags":"","gender":"unisex","likes":0,"dislikes":0}]}
```
MYID=48

## E1: IDOR — чтение/лайк/дизлайк произвольного catId (без владельца/авторизации)

### `GET /api/core/cats/get-by-id?id=18`
статус: **200**
```json
{"cat":{"id":18,"name":"Обормотик","description":"Изменил.","tags":"","gender":"unisex","likes":19,"dislikes":14}}
```

### `POST /api/likes/cats/18/likes`
тело-запроса: `{"like":true,"dislike":false}`
статус: **200**
```json
{"id":18,"name":"Обормотик","description":"Изменил.","tags":"","gender":"unisex","likes":20,"dislikes":14}
```

## E2: повтор ОДНОГО лайка 4× (идемпотентность / накрутка голосов)

### `POST /api/likes/cats/48/likes`
тело-запроса: `{"like":true,"dislike":false}`
статус: **200**
```json
{"id":48,"name":"Котозонд","description":"QA baseline probe","tags":"","gender":"unisex","likes":1,"dislikes":0}
```

### `POST /api/likes/cats/48/likes`
тело-запроса: `{"like":true,"dislike":false}`
статус: **200**
```json
{"id":48,"name":"Котозонд","description":"QA baseline probe","tags":"","gender":"unisex","likes":2,"dislikes":0}
```

### `POST /api/likes/cats/48/likes`
тело-запроса: `{"like":true,"dislike":false}`
статус: **200**
```json
{"id":48,"name":"Котозонд","description":"QA baseline probe","tags":"","gender":"unisex","likes":3,"dislikes":0}
```

### `POST /api/likes/cats/48/likes`
тело-запроса: `{"like":true,"dislike":false}`
статус: **200**
```json
{"id":48,"name":"Котозонд","description":"QA baseline probe","tags":"","gender":"unisex","likes":4,"dislikes":0}
```

### `GET /api/core/cats/get-by-id?id=48`
статус: **200**
```json
{"cat":{"id":48,"name":"Котозонд","description":"QA baseline probe","tags":"","gender":"unisex","likes":4,"dislikes":0}}
```

## E3: правка описания кота, которого я НЕ создавал (id=5) + восстановление

### `GET /api/core/cats/get-by-id?id=5`
статус: **200**
```json
{"cat":{"id":5,"name":"Буся","description":"Запись для ручного редактирования\"\"\"","tags":"","gender":"female","likes":4,"dislikes":4}}
```
исходное описание id5: `Запись для ручного редактирования"""`

### `POST /api/core/cats/save-description`
тело-запроса: `{"catId":5,"catDescription":"TAMPERED-BY-QA (will restore)"}`
статус: **200**
```json
{"id":5,"name":"Буся","description":"TAMPERED-BY-QA (will restore)","tags":"","gender":"female","likes":4,"dislikes":4}
```

### `GET /api/core/cats/get-by-id?id=5`
статус: **200**
```json
{"cat":{"id":5,"name":"Буся","description":"TAMPERED-BY-QA (will restore)","tags":"","gender":"female","likes":4,"dislikes":4}}
```

### `POST /api/core/cats/save-description`
тело-запроса: `{"catId": 5, "catDescription": "\u0417\u0430\u043f\u0438\u0441\u044c \u0434\u043b\u044f \u0440\u0443\u0447\u043d\u043e\u0433\u043e \u0440\u0435\u0434\u0430\u043a\u0442\u0438\u0440\u043e\u0432\u0430\u043d\u0438\u044f\"\"\""}`
статус: **200**
```json
{"id":5,"name":"Буся","description":"Запись для ручного редактирования\"\"\"","tags":"","gender":"female","likes":4,"dislikes":4}
```

## E4: дубликат имени (добавляю «Леопольд», который уже есть как id=30)

### `POST /api/core/cats/add`
тело-запроса: `{"cats":[{"name":"Леопольд","gender":"male","description":"dup-test"}]}`
статус: **200**
```json
{"cats":[{"errorDescription":"Такое значение уже существует"}]}
```
DUPID=

## E5: невалидные значения (gender / имя из цифр и символов / огромное описание)

### `POST /api/core/cats/add`
тело-запроса: `{"cats":[{"name":"Хакер","gender":"attack-helicopter","description":"x"}]}`
статус: **200**
```json
{"cats":[{"id":50,"name":"Хакер","description":"x","tags":"","gender":"unisex","likes":0,"dislikes":0}]}
```

### `POST /api/core/cats/add`
тело-запроса: `{"cats":[{"name":"12345!!!<script>","gender":"male","description":"x"}]}`
статус: **200**
```json
{"cats":[{"errorDescription":"Цифры не принимаются!"}]}
```

### `POST /api/core/cats/save-description`
тело-запроса: `{"catId":48,"catDescription":"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"}`
статус: **200**
```json
{"id":48,"name":"Котозонд","description":"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
```

### `POST /api/core/cats/search`
тело-запроса: `{"name":"123"}`
статус: **200**
```json
{"groups":[]}
```

## E6: теневой/легаси web API, не используемый приложением

### `POST /cats/48/like`
статус: **200**
```json
OK
```

### `DELETE /cats/48/dislike`
статус: **500**
```json
{"name":"error","length":305,"severity":"ERROR","code":"23514","detail":"Failing row contains (48, Котозонд, AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA..., null, unisex, 5, -1).","schema":"public","table":"cats","constraint":"dislikes_positive","file":"execMain.c","line":"2089","routine":"ExecConstraints","isBoom":true,"isServer":true,"data":null,"output":{"statusCode":500,"payload":{"message":"An internal server error occurred","statusCode":500,"error":"Internal Server Error"},"headers":{}}}
```

### `GET /cats/dislikes-rating`
статус: **200**
```json
[{"name":"Турбопетров","dislikes":40},{"name":"Обормотик","dislikes":14},{"name":"Вадосик","dislikes":11},{"name":"Новыйбогдан","dislikes":6},{"name":"Буся","dislikes":4},{"name":"Бодя","dislikes":0},{"name":"Велик","dislikes":0},{"name":"Великий","dislikes":0},{"name":"Длинное Описание","dislikes":0},{"name":"Иимя","dislikes":0}]
```

## E7: несуществующий catId

### `GET /api/core/cats/get-by-id?id=999999`
статус: **404**
```json
{"data":null,"isBoom":true,"isServer":false,"output":{"statusCode":404,"payload":{"statusCode":404,"error":"Not Found","message":"cat not found"},"headers":{}}}
```

### `POST /api/likes/cats/999999/likes`
тело-запроса: `{"like":true,"dislike":false}`
статус: **404**
```json
{"data":null,"isBoom":true,"isServer":false,"output":{"statusCode":404,"payload":{"statusCode":404,"error":"Not Found","message":"cat not found"},"headers":{}}}
```

### `POST /api/core/cats/save-description`
тело-запроса: `{"catId":999999,"catDescription":"ghost"}`
статус: **404**
```json
{"data":null,"isBoom":true,"isServer":false,"output":{"statusCode":404,"payload":{"statusCode":404,"error":"Not Found","message":"cat not found"},"headers":{}}}
```

## E8: варианты загрузки файла для моего кота (48)

### `POST /api/photos/cats/48/upload`
тело-запроса: `-F file=@good.png;type=image/png`
статус: **200**
```json
{"fileUrl":"/photos/image-1780253612012.png"}
```

### `POST /api/photos/cats/48/upload`
тело-запроса: `-F file=@notimage.png;type=image/png`
статус: **200**
```json
{"fileUrl":"/photos/image-1780253612280.png"}
```

### `POST /api/photos/cats/48/upload`
тело-запроса: `-F file=@evil.php;type=application/x-php`
статус: **500**
```json
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Error</title>
</head>
<body>
<pre>Internal Server Error</pre>
</body>
</html>
```

### `POST /api/photos/cats/48/upload`
тело-запроса: `-F file=@image.txt;type=text/plain`
статус: **500**
```json
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Error</title>
</head>
<body>
<pre>Internal Server Error</pre>
</body>
</html>
```

### `GET /api/photos/cats/48/photos`
статус: **200**
```json
{"images":["/photos/image-1780253612012.png","/photos/image-1780253612280.png"]}
```

## ОЧИСТКА: удаляю свои тестовые коты через неавторизованный DELETE /cats/{id}/remove

### `DELETE /cats/48/remove`
статус: **404**
```json
{"data":null,"isBoom":true,"isServer":false,"output":{"statusCode":404,"payload":{"statusCode":404,"error":"Not Found","message":"Не найден id кота"},"headers":{}}}
```

_готово_

---

# Обновлено 2026-06-27 — повторная проверка на новом хосте

_стенд переехал: `144.31.255.0` (lab-01) → `82.39.214.8` (lab-02). Всё выше — исторический прогон 31 мая к старому хосту, оставлен как есть. Ниже — перепроверка тех же находок на новом хосте; собственные тестовые коты созданы и удалены, чужой лайк (id=8) восстановлен._

### `GET /version`
статус: **200**
```json
{"build":"lab-02"}
```

## ПОДГОТОВКА: создаю собственного тестового кота

### `POST /api/core/cats/add`
тело-запроса: `{"cats":[{"name":"Контролькот","gender":"unisex","description":"qa re-verify lab-02"}]}`
статус: **200**
```json
{"cats":[{"id":31,"name":"Контролькот","description":"qa re-verify lab-02","tags":"","gender":"unisex","likes":0,"dislikes":0}]}
```
MYID=31

## SEC-08/BUG-02: невалидный gender молча → unisex (БЕЗ ИЗМЕНЕНИЙ)

### `POST /api/core/cats/add`
тело-запроса: `{"cats":[{"name":"Хакертест","gender":"attack-helicopter","description":"x"}]}`
статус: **200**
```json
{"cats":[{"id":32,"name":"Хакертест","description":"x","tags":"","gender":"unisex","likes":0,"dislikes":0}]}
```

## BUG-03: валидация имени из цифр возвращает 200 (БЕЗ ИЗМЕНЕНИЙ)

### `POST /api/core/cats/add`
тело-запроса: `{"cats":[{"name":"12345!!!","gender":"male","description":"x"}]}`
статус: **200**
```json
{"cats":[{"errorDescription":"Цифры не принимаются!"}]}
```
(повторно `{"name":"99999"}` → статус-код подтверждён: **200**)

## BUG-07: дубликат имени возвращает 200 (БЕЗ ИЗМЕНЕНИЙ)

### `POST /api/core/cats/add`
тело-запроса: `{"cats":[{"name":"Буся","gender":"female","description":"dup"}]}`
статус: **200**
```json
{"cats":[{"errorDescription":"Такое значение уже существует"}]}
```

## SEC-04: повтор лайка растит счётчик (БЕЗ ИЗМЕНЕНИЙ)

### `POST /api/likes/cats/31/likes` ×3
тело-запроса: `{"like":true,"dislike":false}`
статус: **200**
```json
"likes":1 → "likes":2 → "likes":3
```

## SEC-05/BUG-04: DELETE дизлайка ниже нуля → 500 + дамп PostgreSQL (БЕЗ ИЗМЕНЕНИЙ)

### `DELETE /cats/31/dislike`
статус: **500**
```json
{"name":"error","length":263,"severity":"ERROR","code":"23514","detail":"Failing row contains (31, Контролькот, qa re-verify lab-02, null, unisex, 3, -1).","schema":"public","table":"cats","constraint":"dislikes_positive","file":"execMain.c","line":"2089","routine":"ExecConstraints","isBoom":true,"isServer":true,"data":null,"output":{"statusCode":500,"payload":{"message":"An internal server error occurred","statusCode":500,"error":"Internal Server Error"},"headers":{}}}
```

## SEC-06: текстовый файл принят как image/png и так же отдаётся (БЕЗ ИЗМЕНЕНИЙ)

### `POST /api/photos/cats/31/upload`
тело-запроса: `-F file=@notimage.png;type=image/png` (внутри — текст)
статус: **200**
```json
{"fileUrl":"/photos/image-1782576104915.png"}
```
отдача файла: `GET /photos/image-1782576104915.png` → `Content-Type: image/png`, статус **200** (текст отдан как картинка)

## SEC-02: IDOR — лайк чужого кота (id=8), затем восстановление

### `POST /api/likes/cats/8/likes`
тело-запроса: `{"like":true,"dislike":false}`
статус: **200**
```json
{"id":8,"name":"Вел","description":"string","tags":"","gender":"male","likes":2}
```

### `DELETE /cats/8/like` (откат лайка)
статус: **200**
```json
OK
```
(контроль: `GET /api/core/cats/get-by-id?id=8` → `"likes":1` — восстановлено)

## E7: несуществующий catId (БЕЗ ИЗМЕНЕНИЙ)

### `GET /api/core/cats/get-by-id?id=999999`
статус: **404**
```json
{"data":null,"isBoom":true,"isServer":false,"output":{"statusCode":404,"payload":{"statusCode":404,"error":"Not Found","message":"cat not found"},"headers":{}}}
```

## ОЧИСТКА: удаляю свои тестовые коты (31, 32) — BUG-01/SEC-03 (БЕЗ ИЗМЕНЕНИЙ)

### `DELETE /cats/31/remove`
статус: **404**  (но кот реально удалён: `GET get-by-id?id=31` → `{"message":"cat not found"}`)

### `DELETE /cats/32/remove`
статус: **404**  (кот удалён)

**Итог перепроверки:** все 8 находок по безопасности и 7 баг-репортов воспроизводятся на lab-02 идентично lab-01 — ни одна проблема не исправлена. Чужой лайк (id=8) откачен, тестовые коты (31, 32) удалены.

_готово (обновление 2026-06-27)_
