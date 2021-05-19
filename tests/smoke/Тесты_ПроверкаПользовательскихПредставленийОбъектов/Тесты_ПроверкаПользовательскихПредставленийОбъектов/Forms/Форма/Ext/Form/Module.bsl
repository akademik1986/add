﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Утверждения;
&НаКлиенте
Перем СтроковыеУтилиты;
&НаКлиенте
Перем ПрефиксОбъектов;
&НаКлиенте
Перем ОтборПоПрефиксу;
&НаКлиенте
Перем ИсключенияИзПроверок;
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
	
	ОбъектыМетаданных = ОбъектыМетаданных(ПрефиксОбъектов, ОтборПоПрефиксу);
	
	Для Каждого ОбъектМетаданных Из ОбъектыМетаданных Цикл
		
		Если Не ВыводитьИсключения Тогда
			МассивТестов = УбратьИсключения(ОбъектМетаданных.Значение);
		Иначе
			МассивТестов = ОбъектМетаданных.Значение;
		КонецЕсли;
		
		Если МассивТестов.Количество() <> 0 Тогда
			НаборТестов.НачатьГруппу(ОбъектМетаданных.Ключ, Истина);
		КонецЕсли;
		Для Каждого Тест Из МассивТестов Цикл
			НаборТестов.Добавить(Тест.ИмяПроцедуры, НаборТестов.ПараметрыТеста(Тест.ПолноеИмя), Тест.ИмяТеста);	
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

	ОтборПоПрефиксу = Ложь;
	ПрефиксОбъектов = "";
	ИсключенияИзПроверок = Новый Соответствие;
	ВыводитьИсключения = Истина;
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

	Для Каждого ИсключенияИзПроверокПоОбъектам Из Настройки.ИсключенияИзпроверок Цикл
		Для Каждого ИсключениеИзПроверок Из ИсключенияИзПроверокПоОбъектам.Значение Цикл
			ИсключенияИзПроверок.Вставить(ВРег(ИсключенияИзПроверокПоОбъектам.Ключ + "." + ИсключениеИзПроверок), Истина); 	
		КонецЦикла;
	КонецЦикла;	

КонецПроцедуры

#КонецОбласти

#Область Тесты

&НаКлиенте
Процедура ТестДолжен_ПроверитьПользовательскиеПредставленияОбъектов(ПолноеИмяМетаданных) Экспорт
	
	ПропускатьТест = ПропускатьТест(ПолноеИмяМетаданных);
	ТекстОшибки = НСтр("ru = 'Не заполнено ни одно представление объекта.'");
	
	Результат = ПроверитьПользовательскиеПредставленияОбъектовСервер(ПолноеИмяМетаданных);
	Если Не Результат И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ТекстОшибки);
	Иначе
		Утверждения.Проверить(Результат = Истина, ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьПользовательскиеПредставленияОбъектовСервер(ПолноеИмяМетаданных)

	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданных);
	Результат = Ложь;
	СтроковыеУтилиты = СтроковыеУтилиты();
	
	МассивСтрок = СтроковыеУтилиты.РазложитьСтрокуВМассивПодстрок(ПолноеИмяМетаданных, ".");
	Если МассивСтрок.Количество() = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	ЭтоРегистр = СтрНайти(ВРег(МассивСтрок[0]), ВРег("Регистр")) > 0; 
	ПредставлениеОбъекта = ?(ЭтоРегистр, ОбъектМетаданных.ПредставлениеЗаписи, ОбъектМетаданных.ПредставлениеОбъекта);
	
	Если ЗначениеЗаполнено(ПредставлениеОбъекта) Тогда
		Результат = Истина; 
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОбъектМетаданных.ПредставлениеСписка) Тогда
		Результат = Истина;
	КонецЕсли;
	
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
		ШаблонСообщения = НСтр("ru = '""%1"" исключен из проверки.'");
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

&НаСервереБезКонтекста
Функция ОбъектыМетаданных(ПрефиксОбъектов, ОтборПоПрефиксу)
	
	СтроковыеУтилиты = СтроковыеУтилиты();
	Пояснение = НСтр("ru = 'Проверка пользовательского представления объекта'");
	СвойствоПодчинениеРегистратору = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору;
	
	ОбъектыМетаданных = Новый Структура;
	ОбъектыМетаданных.Вставить("ПланыОбмена", Новый Массив);
	ОбъектыМетаданных.Вставить("Справочники", Новый Массив);
	ОбъектыМетаданных.Вставить("Документы", Новый Массив);
	ОбъектыМетаданных.Вставить("ПланыВидовХарактеристик", Новый Массив);
	ОбъектыМетаданных.Вставить("РегистрыСведений", Новый Массив);
	ОбъектыМетаданных.Вставить("БизнесПроцессы", Новый Массив);
	ОбъектыМетаданных.Вставить("Задачи", Новый Массив);
		
	Для Каждого Элемент Из ОбъектыМетаданных Цикл
		Для Каждого ОбъектМетаданных Из Метаданные[Элемент.Ключ] Цикл
			
			Если ОтборПоПрефиксу И Не ИмяСодержитПрефикс(ОбъектМетаданных.Имя, ПрефиксОбъектов) Тогда
				Продолжить;
			КонецЕсли;
			
			Если Метаданные.РегистрыСведений.Содержит(ОбъектМетаданных)
			   И ОбъектМетаданных.РежимЗаписи = СвойствоПодчинениеРегистратору Тогда
				Продолжить;
			КонецЕсли;
			
			ИмяТеста = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1 [%2]", ОбъектМетаданных.ПолноеИмя(), Пояснение);
			
			СтруктураТеста = Новый Структура;
			СтруктураТеста.Вставить("ИмяТеста", ИмяТеста);
			СтруктураТеста.Вставить("ПолноеИмя", ОбъектМетаданных.ПолноеИмя());
			СтруктураТеста.Вставить("ИмяПроцедуры", "ТестДолжен_ПроверитьПользовательскиеПредставленияОбъектов");
			ОбъектыМетаданных[Элемент.Ключ].Добавить(СтруктураТеста);	
			
		КонецЦикла;
	КонецЦикла;
	
	Возврат ОбъектыМетаданных;

КонецФункции

&НаСервереБезКонтекста
Функция СтроковыеУтилиты()
	Возврат ВнешниеОбработки.Создать("СтроковыеУтилиты");	
КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Функция ИмяСодержитПрефикс(Имя, Префикс)
	
	Если Не ЗначениеЗаполнено(Префикс) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДлинаПрефикса = СтрДлина(Префикс);
	Возврат СтрНайти(ВРег(Лев(Имя, ДлинаПрефикса)), Префикс) > 0;
	
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
	ПутьНастройки = ИмяТеста();
	Настройки(КонтекстЯдра, ПутьНастройки);
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