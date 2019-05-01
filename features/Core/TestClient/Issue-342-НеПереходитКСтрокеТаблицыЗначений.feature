# language: ru

@IgnoreOn82Builds
@IgnoreOnOFBuilds



Функционал: Проверка парсинга фичи когда есть тег tree и используется комментарий

Как разработчик
Я хочу чтобы корректно происходил парсинг фичи с включенным тегом tree, когда используется комментарий
Чтобы я мог использовать этот тег в своих фичах


Контекст: 
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: Проверка парсинга фичи, когда используется вертикальная черта
	Когда В панели разделов я выбираю "Основная"
	И     В панели функций я выбираю "Справочник с таблицей значений на форме"
	Тогда открылось окно "Справочник с таблицей значений на форме"
	И     я нажимаю на кнопку "Создать"
	Тогда открылось окно "Справочник с таблицей значений на форме (создание)"
	И     в поле "Наименование" я ввожу текст "111"
	И     я нажимаю на кнопку "Команда1"
	И     В форме "Справочник с таблицей значений на форме *" в таблице "Таблица1" я перехожу к строке:
	| 'Колонка2' | 'Колонка1' |
	| 'Стр3Кол2' | 'Стр3Кол1' |
	И     В форме "Справочник с таблицей значений на форме *" в таблице "Таблица2" я перехожу к строке:
	| 'Колонка2' | 'Колонка1' |
	| 'Стр3Кол2' | 'Стр3Кол1' |
	И Пауза 3
	И     я нажимаю на кнопку "Записать и закрыть"
