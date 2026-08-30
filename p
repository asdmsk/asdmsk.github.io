<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Подтверждение служения</title>
  <style>
    * { box-sizing: border-box; }
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: #f4f5f7; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; padding: 15px; }
    .card { background: #fff; border-radius: 12px; padding: 24px; max-width: 400px; width: 100%; box-shadow: 0 4px 12px rgba(0,0,0,0.08); text-align: center; }
    h3 { margin-top: 0; color: #172b4d; font-size: 20px; }
    .info { background: #f4f5f7; padding: 12px; border-radius: 8px; margin: 15px 0; text-align: left; font-size: 15px; line-height: 1.5; }
    .btn-group { display: flex; gap: 10px; margin-top: 20px; }
    .btn { flex: 1; padding: 12px; border: none; border-radius: 6px; font-size: 15px; font-weight: 600; cursor: pointer; transition: opacity 0.2s; }
    .btn-yes { background: #36b37e; color: white; }
    .btn-no { background: #ff5630; color: white; }
    .btn:hover { opacity: 0.9; }
    .btn:disabled { background: #a5adba; cursor: not-allowed; opacity: 0.6; }
    .msg { margin-top: 15px; font-weight: 500; font-size: 15px; }
    .error { color: #de350b; }
    .success { color: #00875a; }
  </style>
</head>
<body>

<div class="card">
  <h3 id="title">Подтверждение участия</h3>
  
  <div id="content">
    <div class="info">
      <div><strong>Участник:</strong> <span id="fioName">-</span></div>
      <div><strong>Служение:</strong> <span id="serviceName">-</span></div>
    </div>
    <p>Сможете ли вы принять участие?</p>
    
    <div class="btn-group">
      <button id="btnYes" class="btn btn-yes" onclick="sendAnswer('yes')">Да, буду</button>
      <button id="btnNo" class="btn btn-no" onclick="sendAnswer('no')">Нет, не смогу</button>
    </div>
  </div>

  <div id="status" class="msg"></div>
</div>

<script>
  // Справочник типов служения (6 пропущена, Детская история = 7)
  const SERVICES = {
    "1": "Открытие",
    "2": "Субботняя школа",
    "3": "Приветы",
    "4": "Приглашение к служению дарами",
    "5": "Молитва за нужды",
    "7": "Детская история"
  };

  // Тексты ответов для Google Формы
  const ANSWERS = {
    "yes": "Сообщить о своём участии",
    "no": "Сообщить о своём неучастии по любой причине"
  };

  const FORM_URL = "https://docs.google.com/forms/d/e/1FAIpQLSfX9O5WWFqlpjw7UtGmts5_KorRs9y3ENBR4xRslUOVhr2FGg/formResponse";

  // Считываем данные из хэша URL (все что после #)
  const hashData = decodeURIComponent(window.location.hash.substring(1));
  const params = hashData.split('-'); // Разбиваем строку по дефису

  const nameVal = params[0];
  const serviceKey = params[1];

  const contentEl = document.getElementById('content');
  const statusEl = document.getElementById('status');
  const titleEl = document.getElementById('title');

  // Проверка параметров ссылки
  if (!nameVal || !serviceKey || !SERVICES[serviceKey]) {
    contentEl.style.display = "none";
    titleEl.textContent = "Ошибка";
    statusEl.className = "msg error";
    statusEl.textContent = "Некорректная ссылка или отсутствуют параметры.";
  } else {
    document.getElementById('fioName').textContent = nameVal;
    document.getElementById('serviceName').textContent = SERVICES[serviceKey];
  }

  function sendAnswer(type) {
    const btnYes = document.getElementById('btnYes');
    const btnNo = document.getElementById('btnNo');
    
    btnYes.disabled = true;
    btnNo.disabled = true;
    statusEl.className = "msg";
    statusEl.textContent = "Отправка ответа...";

    const serviceText = SERVICES[serviceKey];
    const answerText = ANSWERS[type];

    const formData = new FormData();
    formData.append("entry.565247834", serviceText);
    formData.append("entry.130958526", answerText);
    formData.append("entry.1852639773", "__other_option__");
    formData.append("entry.1852639773.other_option_response", nameVal);

    fetch(FORM_URL, {
      method: "POST",
      mode: "no-cors",
      body: formData
    })
    .then(() => {
      contentEl.style.display = "none";
      titleEl.textContent = "Спасибо!";
      statusEl.className = "msg success";
      statusEl.textContent = "✓ Ваш ответ успешно записан.";
    })
    .catch(err => {
      btnYes.disabled = false;
      btnNo.disabled = false;
      statusEl.className = "msg error";
      statusEl.textContent = "Ошибка отправки. Попробуйте еще раз.";
    });
  }
</script>

</body>
</html>
