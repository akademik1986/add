﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Утверждения;
&НаКлиенте
Перем СтроковыеУтилиты;
&НаКлиенте
Перем ИсключенияИзПроверок;
&НаКлиенте
Перем ОтборПоПрефиксу;
&НаКлиенте
Перем ПрефиксОбъектов;
&НаКлиенте
Перем ВыводитьИсключения;

#КонецОбласти

#Область ИнтерфейсТестирования

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	СтроковыеУтилиты = КонтекстЯдра.Плагин("СтроковыеУтилиты");
	
	Настройки(КонтекстЯдра, ИмяТеста());
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдраПараметр) Экспорт
	
	Инициализация(КонтекстЯдраПараметр);
	
	Если Не ВыполнятьТест(КонтекстЯдра) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураОбъектовМетаданных = СтруктураОбъектовМетаданных(ОтборПоПрефиксу, ПрефиксОбъектов);
	
	Для Каждого ОбъектМетаданных Из СтруктураОбъектовМетаданных Цикл
		Если Не ВыводитьИсключения Тогда
			МассивТестов = УбратьИсключения(ОбъектМетаданных.Значение);
		Иначе
			МассивТестов = ОбъектМетаданных.Значение;
		КонецЕсли;
		Если МассивТестов.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		НаборТестов.НачатьГруппу(ОбъектМетаданных.Ключ, Истина);
		Для Каждого Элемент Из МассивТестов Цикл
			
			НаборТестов.Добавить(
				"ТестДолжен_ПроверитьИндексированиеУстаревшихОбъектовМетаданных", 
				НаборТестов.ПараметрыТеста(Элемент.ПолноеИмя), 
				Элемент.ИмяТеста);
								
		КонецЦикла;
	КонецЦикла;
			
КонецПроцедуры

#КонецОбласти

#Область РаботаСНастройками

&НаКлиенте
Процедура Настройки(КонтекстЯдра, Знач ПутьНастройки)

	Если ЗначениеЗаполнено(Объект.Настройки) Тогда
		Возврат;
	КонецЕсли;
	
	ПрефиксОбъектов = "";
	ОтборПоПрефиксу = Ложь;
	ВыводитьИсключения = Истина;
	ИсключенияИзПроверок = Новый Соответствие;
	ПлагинНастроек = КонтекстЯдра.Плагин("Настройки");
	Объект.Настройки = ПлагинНастроек.ПолучитьНастройку(ПутьНастройки);
	Настройки = Объект.Настройки;
		
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Объект.Настройки = Новый Структура(ПутьНастройки, Неопределено);
		Возврат;
	КонецЕсли;
	
	Если Настройки.Свойство("Префикс") Тогда
		ПрефиксОбъектов = ВРег(Настройки.Префикс);		
	КонецЕсли;
		
	Если Настройки.Свойство("ОтборПоПрефиксу") Тогда
		ОтборПоПрефиксу = Настройки.ОтборПоПрефиксу;		
	КонецЕсли;
	
	Если Настройки.Свойство("ВыводитьИсключения") Тогда
		ВыводитьИсключения = Настройки.ВыводитьИсключения;
	КонецЕсли;
	
	Если Настройки.Свойство("ИсключенияИзПроверок") Тогда
		ИсключенияИзПроверок(Настройки);
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ИсключенияИзПроверок(Настройки)

	Для Каждого ИсключенияИзПроверокПоОбъектам Из Настройки.ИсключенияИзПроверок Цикл
		Для Каждого ИсключениеИзПроверок Из ИсключенияИзПроверокПоОбъектам.Значение Цикл
			ИсключенияИзПроверок.Вставить(ВРег(ИсключенияИзПроверокПоОбъектам.Ключ + "." + ИсключениеИзПроверок), Истина); 	
		КонецЦикла;
	КонецЦикла;	

КонецПроцедуры

#КонецОбласти

#Область Тесты

&НаКлиенте
Процедура ТестДолжен_ПроверитьИндексированиеУстаревшихОбъектовМетаданных(ПолноеИмяМетаданных) Экспорт
	
	ПропускатьТест = ПропускатьТест(ПолноеИмяМетаданных);
	
	Результат = ПроверитьИндексированиеУстаревшихОбъектовМетаданных(ПолноеИмяМетаданных);
	Если Не Результат И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ТекстСообщения(ПолноеИмяМетаданных));
	Иначе
		Утверждения.Проверить(Результат, ТекстСообщения(ПолноеИмяМетаданных));
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьИндексированиеУстаревшихОбъектовМетаданных(ПолноеИмяМетаданных)

	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданных);	
	Результат = (ОбъектМетаданных.Индексирование = Метаданные.СвойстваОбъектов.Индексирование.НеИндексировать);
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПропускатьТест(ПолноеИмяМетаданных)

	Результат = Новый Структура;
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("Пропустить", Ложь);
	
	Если ИсключенИзПроверок(ПолноеИмяМетаданных) Тогда
		ШаблонСообщения = НСтр("ru = 'Объект ""%1"" исключен из проверки'");
		Результат.ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПолноеИмяМетаданных);
		Результат.Пропустить = Истина;
		Возврат Результат;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции 

&НаКлиенте
Функция ИсключенИзПроверок(ПолноеИмяМетаданных)
	
	Результат = Ложь;
	МассивСтрокИмени = СтроковыеУтилиты.РазложитьСтрокуВМассивПодстрок(ПолноеИмяМетаданных, ".");
	ИслючениеВсехОбъектов = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1.*", МассивСтрокИмени[0]);
	
	Если ИсключенияИзПроверок.Получить(ВРег(ПолноеИмяМетаданных)) <> Неопределено
	 Или ИсключенияИзПроверок.Получить(ВРег(ИслючениеВсехОбъектов)) <> Неопределено Тогда
		Результат = Истина;	
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция УбратьИсключения(МассивТестов)

	Результат = Новый Массив;
	
	Для Каждого Тест Из МассивТестов Цикл
		Если Не ИсключенИзПроверок(Тест.ПолноеИмя) Тогда
			Результат.Добавить(Тест);
		КонецЕсли;	
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Функция ТекстСообщения(ПолноеИмяМетаданных)

	ШаблонСообщения = НСтр("ru = 'У свойства ""%1"" включено индексирование.'");
	ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПолноеИмяМетаданных);
	
	Возврат ТекстСообщения;

КонецФункции

&НаСервереБезКонтекста
Функция СтруктураОбъектовМетаданных(ОтборПоПрефиксу, ПрефиксОбъектов)
		
	МассивИменОбъектовМетаданных = МассивИменОбъектовМетаданных();
	СтроковыеУтилиты = СтроковыеУтилиты();
		
	СтруктураОбъектовМетаданных = Новый Структура;
	Для Каждого ЭлементМассива Из МассивИменОбъектовМетаданных Цикл
		СтруктураОбъектовМетаданных.Вставить(ЭлементМассива, Новый Массив);
	КонецЦикла;
		
	Для Каждого ЭлементСтруктурыОбъектовМетаданных Из СтруктураОбъектовМетаданных Цикл
		Для Каждого ОбъектМетаданных Из Метаданные[ЭлементСтруктурыОбъектовМетаданных.Ключ] Цикл
			
			мОтборПоПрефиксу = ОтборПоПрефиксу И Не ИмяСодержитПрефикс(ОбъектМетаданных.Имя, ПрефиксОбъектов);
			ВключитьВсеЭлементы = ЭтоУстаревшийОбъектМетаданных(ОбъектМетаданных.Имя);			
			
			Параметры = Новый Структура;
			Параметры.Вставить("ОбъектМетаданных", ОбъектМетаданных);
			Параметры.Вставить("СтруктураОбъектовМетаданных", СтруктураОбъектовМетаданных);
			Параметры.Вставить("ИмяМетаданных", ЭлементСтруктурыОбъектовМетаданных.Ключ);
			Параметры.Вставить("ОтборПоПрефиксу", мОтборПоПрефиксу);
			Параметры.Вставить("ПрефиксОбъектов", ПрефиксОбъектов);
			Параметры.Вставить("СтроковыеУтилиты", СтроковыеУтилиты);
			Параметры.Вставить("ВключитьВсеЭлементы", ВключитьВсеЭлементы);
			
			ОбработатьЭлементыОбъектаМетаданных(Параметры, "ЗначенияПеречисления");
			ОбработатьЭлементыОбъектаМетаданных(Параметры, "Измерения");
			Если Метаданные.РегистрыСведений.Содержит(ОбъектМетаданных) Тогда
				ОбработатьЭлементыОбъектаМетаданных(Параметры, "Ресурсы");
			КонецЕсли;
			ОбработатьЭлементыОбъектаМетаданных(Параметры, "Реквизиты");
			ОбработатьТабличныеЧастиОбъектаМетаданных(Параметры, "ТабличныеЧасти");
			ОбработатьЭлементыОбъектаМетаданных(Параметры, "Графы");
			ОбработатьЭлементыОбъектаМетаданных(Параметры, "РеквизитыАдресации");

			
		КонецЦикла;
	КонецЦикла;
	
	Возврат СтруктураОбъектовМетаданных;

КонецФункции

&НаСервереБезКонтекста
Процедура ОбработатьТабличныеЧастиОбъектаМетаданных(Параметры, ИмяКоллекции)

	ОбъектМетаданных = Параметры.ОбъектМетаданных;
	СтруктураОбъектовМетаданных = Параметры.СтруктураОбъектовМетаданных;
	ИмяМетаданных = Параметры.ИмяМетаданных;
	ОтборПоПрефиксу = Параметры.ОтборПоПрефиксу;
	ПрефиксОбъектов = Параметры.ПрефиксОбъектов;
	СтроковыеУтилиты = Параметры.СтроковыеУтилиты;
	ВключитьВсеЭлементы = Параметры.ВключитьВсеЭлементы;
	
	Если Не ЕстьРеквизитИлиСвойствоОбъекта(ОбъектМетаданных, ИмяКоллекции) Тогда
		Возврат;
	КонецЕсли;
		
	Для Каждого ЭлементКоллекции Из ОбъектМетаданных[ИмяКоллекции] Цикл
		
		ОбработатьВсеРеквизиты = ВключитьВсеЭлементы;
		
		Если ВключитьВсеЭлементы Или ЭтоУстаревшийОбъектМетаданных(ЭлементКоллекции.Имя) Тогда
			
			Если ОтборПоПрефиксу И Не ИмяСодержитПрефикс(ЭлементКоллекции.Имя, ПрефиксОбъектов) Тогда
				Продолжить;
			КонецЕсли;
				
			ОбработатьВсеРеквизиты = Истина;
			
		КонецЕсли;
		
		мПараметры = Новый Структура;
		мПараметры.Вставить("ОбъектМетаданных", ЭлементКоллекции);
		мПараметры.Вставить("СтруктураОбъектовМетаданных", СтруктураОбъектовМетаданных);
		мПараметры.Вставить("ИмяМетаданных", ИмяМетаданных);
		мПараметры.Вставить("ОтборПоПрефиксу", ОтборПоПрефиксу);
		мПараметры.Вставить("ПрефиксОбъектов", ПрефиксОбъектов);
		мПараметры.Вставить("СтроковыеУтилиты", СтроковыеУтилиты);
		мПараметры.Вставить("ВключитьВсеЭлементы", ОбработатьВсеРеквизиты);
		
		ОбработатьЭлементыОбъектаМетаданных(мПараметры, "Реквизиты");
				
	КонецЦикла;

КонецПроцедуры 

&НаСервереБезКонтекста
Процедура ОбработатьЭлементыОбъектаМетаданных(Параметры, ИмяКоллекции)

	ОбъектМетаданных = Параметры.ОбъектМетаданных;
	СтруктураОбъектовМетаданных = Параметры.СтруктураОбъектовМетаданных;
	ИмяМетаданных = Параметры.ИмяМетаданных;
	ОтборПоПрефиксу = Параметры.ОтборПоПрефиксу;
	ПрефиксОбъектов = Параметры.ПрефиксОбъектов;
	СтроковыеУтилиты = Параметры.СтроковыеУтилиты;
	ВключитьВсеЭлементы = Параметры.ВключитьВсеЭлементы;
	
	Если Не ЕстьРеквизитИлиСвойствоОбъекта(ОбъектМетаданных, ИмяКоллекции) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлементКоллекции Из ОбъектМетаданных[ИмяКоллекции] Цикл
		
		Если ОтборПоПрефиксу И Не ИмяСодержитПрефикс(ЭлементКоллекции.Имя, ПрефиксОбъектов) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ВключитьВсеЭлементы Или ЭтоУстаревшийОбъектМетаданных(ЭлементКоллекции.Имя) Тогда
			ДобавитьЭлементКоллекцииОбъектовМетаданных(
				СтроковыеУтилиты,
				СтруктураОбъектовМетаданных[ИмяМетаданных], 
				ЭлементКоллекции.ПолноеИмя());	
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры 

&НаСервереБезКонтекста
Процедура ДобавитьЭлементКоллекцииОбъектовМетаданных(СтроковыеУтилиты, Коллекция, ПолноеИмя)

	ИмяТеста = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(
				"%1 [%2]", 
				ПолноеИмя, 
				НСтр("ru = 'Проверка индексов устаревшего объекта'"));
	
	СтруктураЭлемента = Новый Структура;
	СтруктураЭлемента.Вставить("ПолноеИмя", ПолноеИмя);
	СтруктураЭлемента.Вставить("ИмяТеста", ИмяТеста);
	Коллекция.Добавить(СтруктураЭлемента);

КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Функция ЕстьРеквизитИлиСвойствоОбъекта(Объект, ИмяРеквизита) Экспорт
	
	КлючУникальности   = Новый УникальныйИдентификатор;
	СтруктураРеквизита = Новый Структура(ИмяРеквизита, КлючУникальности);
	ЗаполнитьЗначенияСвойств(СтруктураРеквизита, Объект);
	
	Возврат СтруктураРеквизита[ИмяРеквизита] <> КлючУникальности;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоУстаревшийОбъектМетаданных(ИмяОбъектаМетаданных)
	КоличествоБуквОтступа = 7;
	Возврат СтрНайти(ВРег(Лев(ИмяОбъектаМетаданных, КоличествоБуквОтступа)), "УДАЛИТЬ");
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция МассивИменОбъектовМетаданных()

	МассивИменОбъектовМетаданных = Новый Массив;
	                                 
	МассивИменОбъектовМетаданных.Добавить("ОбщиеРеквизиты");
	МассивИменОбъектовМетаданных.Добавить("ПланыОбмена");
	МассивИменОбъектовМетаданных.Добавить("КритерииОтбора");
	МассивИменОбъектовМетаданных.Добавить("ХранилищаНастроек");
	МассивИменОбъектовМетаданных.Добавить("Справочники");
	МассивИменОбъектовМетаданных.Добавить("Документы");
	МассивИменОбъектовМетаданных.Добавить("ЖурналыДокументов");
	МассивИменОбъектовМетаданных.Добавить("ПланыВидовХарактеристик");
	МассивИменОбъектовМетаданных.Добавить("ПланыСчетов");
	МассивИменОбъектовМетаданных.Добавить("ПланыВидовРасчета");
	МассивИменОбъектовМетаданных.Добавить("РегистрыСведений");
	МассивИменОбъектовМетаданных.Добавить("РегистрыНакопления");
	МассивИменОбъектовМетаданных.Добавить("РегистрыБухгалтерии");
	МассивИменОбъектовМетаданных.Добавить("РегистрыРасчета");
	МассивИменОбъектовМетаданных.Добавить("БизнесПроцессы");
	МассивИменОбъектовМетаданных.Добавить("Задачи");
	МассивИменОбъектовМетаданных.Добавить("ВнешниеИсточникиДанных");
	
	Возврат МассивИменОбъектовМетаданных;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяСодержитПрефикс(Имя, Префикс)
	
	Если Не ЗначениеЗаполнено(Префикс) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДлинаПрефикса = СтрДлина(Префикс);
	Возврат СтрНайти(ВРег(Лев(Имя, ДлинаПрефикса)), Префикс) > 0;
	
КонецФункции

&НаСервереБезКонтекста
Функция СтроковыеУтилиты()
	Возврат ВнешниеОбработки.Создать("СтроковыеУтилиты");	
КонецФункции 

&НаКлиенте
Функция ИмяТеста()
	
	Если Не ЗначениеЗаполнено(Объект.ИмяТеста) Тогда
		Объект.ИмяТеста = ИмяТестаНаСервере();
	КонецЕсли;
	
	Возврат Объект.ИмяТеста;
	
КонецФункции

&НаСервере
Функция ИмяТестаНаСервере()
	Возврат РеквизитФормыВЗначение("Объект").Метаданные().Имя;
КонецФункции

&НаКлиенте
Функция ВыполнятьТест(КонтекстЯдра)
	
	ВыполнятьТест = Ложь;
	Настройки(КонтекстЯдра, ИмяТеста());
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Возврат ВыполнятьТест;
	КонецЕсли;
		
	Если ТипЗнч(Настройки) = Тип("Структура") И Настройки.Свойство("Используется") Тогда
		ВыполнятьТест = Настройки.Используется;	
	КонецЕсли;
	
	Возврат ВыполнятьТест;

КонецФункции

#КонецОбласти