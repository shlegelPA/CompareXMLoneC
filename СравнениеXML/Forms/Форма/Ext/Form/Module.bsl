﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	 
	ДеревоИзменений = Новый ДеревоЗначений;
	ДеревоИзменений.Колонки.Добавить("Объект");
	ДеревоИзменений.Колонки.Добавить("ВерсияXML1");
	ДеревоИзменений.Колонки.Добавить("ВерсияXML2");
	ДеревоИзменений.Колонки.Добавить("ОбъектСвойство");
	ДеревоИзменений.Колонки.Добавить("ВерсияXML1Свойство");
	ДеревоИзменений.Колонки.Добавить("ВерсияXML2Свойство");
	ДеревоИзменений.Колонки.Добавить("ВерсияXMLИсходящая");
	ДеревоИзменений.Колонки.Добавить("ИзменениеВерсии1", Новый ОписаниеТипов("Число"));
	ДеревоИзменений.Колонки.Добавить("ИзменениеВерсии2", Новый ОписаниеТипов("Число"));
	ДеревоИзменений.Колонки.Добавить("ИмяСтрокой");
	ДеревоИзменений.Колонки.Добавить("ВзятьИзОбъекта");
	ДеревоИзменений.Колонки.Добавить("ВзятьИзВерсии1");
	ДеревоИзменений.Колонки.Добавить("ВзятьИзВерсии2");
	ДеревоИзменений.Колонки.Добавить("ПропуститьПроверку");
	
	
	АдресДерева = ПоместитьВоВременноеХранилище(ДеревоИзменений, ЭтаФорма.УникальныйИдентификатор);
	
	КаталогРепозитория = "<Выберите папку с GIT-Репозиторием проекта>";
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьДанные(Команда)
	СформироватьДеревоЗначений();
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаРаботаСДанными;
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоЗначений()
	
	ДеревоИзменений = ПолучитьИзВременногоХранилища(АдресДерева);
	ДеревоИзменений.Строки.Очистить();
	
	ЗаполнитьДеревоОбщимПредком(ДеревоИзменений);
		
	ЗначениеВРеквизитФормы(ДеревоИзменений, "ДеревоИзмененийФормы");
	АдресДерева = ПоместитьВоВременноеХранилище(ДеревоИзменений, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоОбщимПредком(Дерево)
	
	ОбъектЧтения = ПрочитатьXMLвXDTO(Объект.ОбщийПредокXML);
	
	Корень = Дерево.Строки.Добавить();
	Корень.Объект = ОбъектЧтения;
	Корень.ИмяСтрокой = "Корень";
	
	ПрочитатьXDTOвДеревоРекурсивно(Корень, ОбъектЧтения);
	
	ВерсияЧтения = ПрочитатьXMLвXDTO(Объект.ВерсияXML1);
	Корень.ВерсияXML1 = ВерсияЧтения;
	ПрочитатьXDTOвДеревоРекурсивно(Корень, ВерсияЧтения, "ВерсияXML1");
	
	Если ЗначениеЗаполнено(Объект.ВерсияXML2) Тогда
		ВерсияЧтения = ПрочитатьXMLвXDTO(Объект.ВерсияXML2);
		Корень.ВерсияXML2 = ВерсияЧтения;
		ПрочитатьXDTOвДеревоРекурсивно(Корень, ВерсияЧтения, "ВерсияXML2");
	КонецЕсли;
	
	СобратьИсходящееДеревоРекурсивно(Дерево);
	
КонецПроцедуры

&НаСервере
Процедура СобратьИсходящееДеревоРекурсивно(Дерево)
	
	Для Каждого Строка Из Дерево.Строки Цикл
		
		Строка.ВзятьИзВерсии2 = Ложь;
		Строка.ВзятьИзВерсии1 = Ложь;
		Строка.ВзятьИзОбъекта = Ложь;
		
		Если ЭтоПростойТип(Строка.Объект) 
			И ЭтоПростойТип(Строка.ВерсияXML2) 
			И ЭтоПростойТип(Строка.ВерсияXML1) Тогда
			
			Если Строка.Объект = Строка.ВерсияXML1 И Строка.Объект <> Строка.ВерсияXML2 Тогда
				Строка.ВерсияXMLИсходящая = Строка.ВерсияXML2;
				Строка.ВзятьИзВерсии2 = Истина;
				Строка.ИзменениеВерсии2 = 1;
				ДобавитьИзменениеРодителю(Строка, "ИзменениеВерсии2");
			ИначеЕсли Строка.Объект <> Строка.ВерсияXML1 И Строка.Объект = Строка.ВерсияXML2 Тогда
				Строка.ВерсияXMLИсходящая = Строка.ВерсияXML1;
				Строка.ВзятьИзВерсии1 = Истина;
				Строка.ИзменениеВерсии1 = 1;
				ДобавитьИзменениеРодителю(Строка, "ИзменениеВерсии1");
			ИначеЕсли Строка.Объект = Строка.ВерсияXML1 И Строка.Объект = Строка.ВерсияXML2 Тогда
				Строка.ВерсияXMLИсходящая = Строка.Объект;
				Строка.ВзятьИзОбъекта = Истина;
			КонецЕсли;
			
		Иначе
			
			Если Строка.ВерсияXML1 <> Неопределено И Строка.Объект <> Неопределено И Строка.ВерсияXML2 = Неопределено Тогда
				Строка.ВерсияXMLИсходящая = Строка.ВерсияXML2;
				Строка.ВзятьИзВерсии2 = Истина;
				Строка.ИзменениеВерсии2 = 1;
				ДобавитьИзменениеРодителю(Строка, "ИзменениеВерсии2");
			ИначеЕсли Строка.ВерсияXML1 = Неопределено И Строка.ВерсияXML2 <> Неопределено Тогда
				Строка.ВерсияXMLИсходящая = Строка.ВерсияXML2;
				Строка.ВзятьИзВерсии2 = Истина;
				Строка.ИзменениеВерсии2 = 1;
				ДобавитьИзменениеРодителю(Строка, "ИзменениеВерсии2");
			ИначеЕсли Строка.ВерсияXML1 <> Неопределено И Строка.Объект = Неопределено И Строка.ВерсияXML2 = Неопределено Тогда
				Строка.ВерсияXMLИсходящая = Строка.ВерсияXML1;
				Строка.ВзятьИзВерсии1 = Истина;
				Строка.ИзменениеВерсии1 = 1;
				ДобавитьИзменениеРодителю(Строка, "ИзменениеВерсии1");
			ИначеЕсли Строка.ВерсияXML1 <> Неопределено И Строка.ВерсияXML2 <> Неопределено И Строка.Объект <> Неопределено Тогда
				Строка.ВерсияXMLИсходящая = Строка.Объект;
				Строка.ВзятьИзОбъекта = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
		СобратьИсходящееДеревоРекурсивно(Строка);
		//Строка.Строки.Сортировать("ИмяСтрокой");
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьXDTOвДеревоРекурсивно(ЭлементДерева, ЭлементXDTO, ЗаполнитьВерсию = "Объект")
	
	Если ТипЗнч(ЭлементXDTO) = Тип("ОбъектXDTO") Тогда
		Для Каждого Свойство Из ЭлементXDTO.Свойства() Цикл
			ИзменяемаяСтрокаДерева = ДобавитьВДерево(ЭлементДерева, ЭлементXDTO[Свойство.Имя], Свойство, ЗаполнитьВерсию, Свойство.Имя);
			ПрочитатьXDTOвДеревоРекурсивно(ИзменяемаяСтрокаДерева, ЭлементXDTO[Свойство.Имя], ЗаполнитьВерсию);
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ЭлементXDTO) = Тип("СписокXDTO") Тогда
		НумераторСписка = 1;
		Для Каждого ЭлементСписка Из ЭлементXDTO Цикл
			ИзменяемаяСтрокаДерева = ДобавитьВДерево(ЭлементДерева, ЭлементСписка, ЭлементXDTO.ВладеющееСвойство, ЗаполнитьВерсию,,НумераторСписка);
			ПрочитатьXDTOвДеревоРекурсивно(ИзменяемаяСтрокаДерева, ЭлементСписка, ЗаполнитьВерсию);
			НумераторСписка = НумераторСписка + 1;
		КонецЦикла;
	//Иначе
		//ДобавитьВДерево(ЭлементДерева, ЭлементXDTO, ЗаполнитьВерсию);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Функция ДобавитьВДерево(ЭлементДерева, ЭлементXDTO, Свойство = Неопределено, ЗаполнитьВерсию, ИмяСтрокой = "", НумераторСписка = 0)
	
	Если Не ЗначениеЗаполнено(ИмяСтрокой) Тогда
		ИмяСтрокой = ПолучитьИмяXDTO(ЭлементXDTO, НумераторСписка);
	КонецЕсли;
	
	Если ЗаполнитьВерсию <> "Объект" Тогда
		СтрокаДерева = ЭлементДерева.Строки.Найти(ИмяСтрокой, "ИмяСтрокой");
	КонецЕсли;
	
	Если СтрокаДерева = Неопределено Тогда
		СтрокаДерева = ЭлементДерева.Строки.Добавить();
		СтрокаДерева.ИмяСтрокой = ИмяСтрокой;
	КонецЕсли;
	
	СтрокаДерева[ЗаполнитьВерсию] = ЭлементXDTO;
	СтрокаДерева[ЗаполнитьВерсию + "Свойство"] = Свойство;	
	Возврат СтрокаДерева;
			
КонецФункции

&НаСервере
Функция ПолучитьИмяXDTO(ЭлементXDTO, НумераторСписка)
	
	Если ТипЗнч(ЭлементXDTO) = Тип("СвойствоXDTO") Тогда
		
		Возврат ЭлементXDTO.Имя;
		
	ИначеЕсли ТипЗнч(ЭлементXDTO) = Тип("ОбъектXDTO") Тогда
		
		Если ЭлементXDTO.Свойства().Получить("name") <> Неопределено Тогда
			Возврат ЭлементXDTO.name;
		ИначеЕсли ЭлементXDTO.Свойства().Получить("uuid") <> Неопределено Тогда
			Возврат ЭлементXDTO.uuid;
		Иначе
			Постфикс = ?(НумераторСписка = 0, "", "#№_" + Строка(НумераторСписка));
			Возврат ЭлементXDTO.ВладеющееСвойство().Имя + Постфикс;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ЭлементXDTO) = Тип("СписокXDTO") Тогда
		
		Возврат ЭлементXDTO.ВладеющееСвойство.Имя;
		
	Иначе
		Возврат ЭлементXDTO;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПрочитатьXMLвXDTO(XML)
	
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(XML);
	Возврат ФабрикаXDTO.ПрочитатьXML(Чтение);
	
КонецФункции

&НаСервере
Процедура ДобавитьИзменениеРодителю(СтрокаДерева, ИзменениеВерсии)
	Если СтрокаДерева.Родитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	СтрокаДерева.Родитель[ИзменениеВерсии] = СтрокаДерева.Родитель[ИзменениеВерсии] + 1;
	ДобавитьИзменениеРодителю(СтрокаДерева.Родитель, ИзменениеВерсии);
	
КонецПроцедуры

&НаСервере
Функция ЭтоПростойТип(Значение)
	Возврат ТипЗнч(Значение) = Тип("Строка") 
			ИЛИ ТипЗнч(Значение) = Тип("Число") 
			ИЛИ ТипЗнч(Значение) = Тип("Булево") 
			ИЛИ Значение = Неопределено;
КонецФункции




#Область РаботаСGIT

&НаКлиенте
Процедура КаталогРепозиторияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Описание = Новый ОписаниеОповещения("ВыборКаталога_Завершение", ЭтаФорма);
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Показать(Описание);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКаталога_Завершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КаталогРепозитория = Результат[0];
	
	ПолучитьСписокФайловСКонфликтами();
КонецПроцедуры

&НаКлиенте
Функция ВыполнитьКомандуGIT(КомандаGIT)
	
	ФайлОтветаGIT = ПолучитьИмяВременногоФайла(); 
	
	//Описание = Новый ОписаниеОповещения("ВыполнитьКомандуGIT_Завершение", ЭтаФорма, ДополнительныеПараметры);
	КомандаСистемы("git " + КомандаGIT + " > " + ФайлОтветаGIT, КаталогРепозитория);
	
	Попытка
		Текст = Новый ЧтениеТекста();
		Текст.Открыть(ФайлОтветаGIT, КодировкаТекста.UTF8);
		Ответ = Новый Массив;
		Строка = "";
		Пока Истина Цикл
			Строка = Текст.ПрочитатьСтроку();
			Если Строка = Неопределено Тогда
				Прервать;
			КонецЕсли;
			
			Ответ.Добавить(Строка);
			
		КонецЦикла;
		Текст.Закрыть();
		
		УдалитьФайлы(ФайлОтветаGIT);
		
		Возврат Ответ;
		
	Исключение
		ВызватьИсключение("Ошибка исполнения команды GIT: " + ОписаниеОшибки());
	КонецПопытки;
	
КонецФункции

&НаКлиенте
Процедура ПолучитьСписокФайловСКонфликтами(Команда = Неопределено)
	
	Если Не ЗначениеЗаполнено(КаталогРепозитория) ИЛИ КаталогРепозитория = "<Выберите папку с GIT-Репозиторием проекта>" Тогда
		ПоказатьОповещениеПользователя("Не выбран каталог",,"Не выбран каталог репозитория GIT.");
		Возврат;
	КонецЕсли;
	
	
	Ответ = ВыполнитьКомандуGIT("diff --name-only --diff-filter=U");
	
	СписокФайловСКонфликтами.Очистить();
	Для Каждого Путь Из Ответ Цикл
		
		Файл = Новый Файл(Путь);
		НоваяСтрока = СписокФайловСКонфликтами.Добавить();
		НоваяСтрока.Имя = файл.ИмяБезРасширения;
		НоваяСтрока.Расширение = Файл.Расширение;
		НоваяСтрока.Путь = Файл.Путь;
		НоваяСтрока.ПолныйПуть = Путь;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СравнитьВерсииФайла(Команда = Неопределено)
	
	ТекущийВыбор = Элементы.СписокФайловСКонфликтами.ТекущиеДанные;
	Если ТекущийВыбор = Неопределено Тогда
		ПоказатьОповещениеПользователя("Не выбран файл",,"Выделите строку с файлом в списке файлов.");
		Возврат;
	КонецЕсли;
	
	Ответ = ВыполнитьКомандуGIT("show -s --format=%H HEAD");
	КоммитТекущейВетки = Ответ[0];
	
	Ответ = ВыполнитьКомандуGIT("show -s --format=%H MERGE_HEAD");
	КоммитВходящейВетки = Ответ[0];
	
	Ответ = ВыполнитьКомандуGIT("merge-base HEAD MERGE_HEAD");
	РодительскийКоммит = Ответ[0];
	
	Объект.ВерсияXML1 = "";
	Объект.ВерсияXML2 = "";
	Объект.ОбщийПредокXML = "";
	
	Ответ = ВыполнитьКомандуGIT("show --textconv " + КоммитТекущейВетки + ":" + ТекущийВыбор.ПолныйПуть);
	Для Каждого СтрокаОтвета Из Ответ Цикл
		Объект.ВерсияXML1 = Объект.ВерсияXML1 + СтрокаОтвета + Символы.ПС;
	КонецЦикла;
	
	Ответ = ВыполнитьКомандуGIT("show --textconv " + КоммитВходящейВетки + ":" + ТекущийВыбор.ПолныйПуть);
	Для Каждого СтрокаОтвета Из Ответ Цикл
		Объект.ВерсияXML2 = Объект.ВерсияXML2 + СтрокаОтвета + Символы.ПС;
	КонецЦикла;
	
	Ответ = ВыполнитьКомандуGIT("show --textconv " + РодительскийКоммит + ":" + ТекущийВыбор.ПолныйПуть);
	Для Каждого СтрокаОтвета Из Ответ Цикл
		Объект.ОбщийПредокXML = Объект.ОбщийПредокXML + СтрокаОтвета + Символы.ПС;
	КонецЦикла;
	
	СформироватьДеревоЗначений();
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаРаботаСДанными;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловСКонфликтамиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	СравнитьВерсииФайла();
КонецПроцедуры

#КонецОбласти




#Область РаботаСДеревом

&НаКлиенте
Процедура ДеревоИзмененийВзятьИзОбъектаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ДеревоИзменений.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ТекущиеДанные.ВзятьИзОбъекта Тогда
		ТекущиеДанные.ВзятьИзОбъекта = Истина;
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.ВзятьИзВерсии1 = НЕ ТекущиеДанные.ВзятьИзОбъекта;
	ТекущиеДанные.ВзятьИзВерсии2 = НЕ ТекущиеДанные.ВзятьИзОбъекта;
	ТекущиеДанные.ПропуститьПроверку = НЕ ТекущиеДанные.ВзятьИзОбъекта;
	
	ТекущиеДанные.ВерсияXMLИсходящая = ТекущиеДанные.Объект;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоИзмененийВзятьИзВерсии1ПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ДеревоИзменений.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ТекущиеДанные.ВзятьИзВерсии1 Тогда
		ТекущиеДанные.ВзятьИзВерсии1 = Истина;
		Возврат;
	КонецЕсли;
	
	
	ТекущиеДанные.ВзятьИзОбъекта = НЕ ТекущиеДанные.ВзятьИзВерсии1;
	ТекущиеДанные.ВзятьИзВерсии2 = НЕ ТекущиеДанные.ВзятьИзВерсии1;
	ТекущиеДанные.ПропуститьПроверку = НЕ ТекущиеДанные.ВзятьИзВерсии1;
	
	ТекущиеДанные.ВерсияXMLИсходящая = ТекущиеДанные.ВерсияXML1;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоИзмененийВзятьИзВерсии2ПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ДеревоИзменений.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ТекущиеДанные.ВзятьИзВерсии2 Тогда
		ТекущиеДанные.ВзятьИзВерсии2 = Истина;
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.ВзятьИзОбъекта = НЕ ТекущиеДанные.ВзятьИзВерсии2;
	ТекущиеДанные.ВзятьИзВерсии1 = НЕ ТекущиеДанные.ВзятьИзВерсии2;
	ТекущиеДанные.ПропуститьПроверку = НЕ ТекущиеДанные.ВзятьИзВерсии2;
	
	ТекущиеДанные.ВерсияXMLИсходящая = ТекущиеДанные.ВерсияXML2;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоИзмененийПропуститьПроверкуПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ДеревоИзменений.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ТекущиеДанные.ПропуститьПроверку Тогда
		ТекущиеДанные.ПропуститьПроверку = Истина;
		Возврат;
	КонецЕсли;

	Описание = Новый ОписаниеОповещения("ПропуститьПроверкуИзменение_Завершение", ЭтаФорма, ТекущиеДанные);
	ПоказатьВопрос(Описание, 
					"Элемент и его подчиненные будут пропущены при сборке исходящего файла. Продолжить?", 
					РежимДиалогаВопрос.ДаНет, 
					,
					КодВозвратаДиалога.Да,
					"Пропустить элемент?");
					
КонецПроцедуры

&НаКлиенте
Процедура ПропуститьПроверкуИзменение_Завершение(Результат, ТекущиеДанные) Экспорт
	Если Результат = КодВозвратаДиалога.Нет Тогда
		ТекущиеДанные.ПропуститьПроверку = Ложь;
	Иначе
		ТекущиеДанные.ВзятьИзОбъекта = НЕ ТекущиеДанные.ПропуститьПроверку;
		ТекущиеДанные.ВзятьИзВерсии1 = НЕ ТекущиеДанные.ПропуститьПроверку;
		ТекущиеДанные.ВзятьИзВерсии2 = НЕ ТекущиеДанные.ПропуститьПроверку;
		
		ТекущиеДанные.ВерсияXMLИсходящая = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти



#Область СборкаИсходника

&НаКлиенте
Процедура СобратьИсходник(Команда)
	СобратьИсходникНаСервере();	
КонецПроцедуры

&НаСервере
Процедура СобратьИсходникНаСервере()
	
	ДеревоИзменений = ПолучитьИзВременногоХранилища(АдресДерева);
	
	КореньДерева = ДеревоИзменений.Строки[0];
	
	СборкаXDTO = ФабрикаXDTO.Создать(КореньДерева.Объект.Тип()); 
	
	СобратьXDTOРекурсивно(КореньДерева, СборкаXDTO, ДеревоИзмененийФормы.ПолучитьЭлементы()[0]);
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, СборкаXDTO);
	Объект.ИсходящийXML = ЗаписьXML.Закрыть(); 
	
	
	//ДеревоИзмененийФормы.НайтиПоИдентификатору(	
КонецПроцедуры

/////////
//////
/////////
//////////
////////
//////////
///////
&НаСервере
Процедура СобратьXDTOРекурсивно(ЭлементДерева, СборкаXDTO, СтрокаДереваФормы)
	
	
	ЭлементыФормы = СтрокаДереваФормы.ПолучитьЭлементы();
	Для Каждого СтрокаДерева Из ЭлементДерева.Строки Цикл
		
		ЗначенияФормы = ЭлементыФормы[ЭлементДерева.Строки.Индекс(СтрокаДерева)];
		Если ЗначенияФормы.ВзятьИзОбъекта Тогда
			
			ПолеОбъект = "Объект";
			ПолеСвойство = "ОбъектСвойство";
			
		КонецЕсли;
		
		Если ЗначенияФормы.ВзятьИзВерсии1 Тогда	
			
			ПолеОбъект = "ВерсияXML1";
			ПолеСвойство = "ВерсияXML1Свойство";
			
		КонецЕсли;

		Если ЗначенияФормы.ВзятьИзВерсии2 Тогда	
			
			ПолеОбъект = "ВерсияXML2";
			ПолеСвойство = "ВерсияXML2Свойство";
			
		КонецЕсли;
		
		Если ТипЗнч(СтрокаДерева[ПолеОбъект]) = Тип("СписокXDTO") Тогда
			Если СборкаXDTO.Свойства().Получить(СтрокаДерева[ПолеСвойство].Имя) = Неопределено Тогда
				
				Форма = СтрокаДерева[ПолеСвойство].Форма;
				ПространствоИмен = СтрокаДерева[ПолеСвойство].URIПространстваИмен;
				Имя = СтрокаДерева[ПолеСвойство].Имя;
				ОбъектСписокXDTO = ФабрикаXDTO.Создать(СтрокаДерева[ПолеОбъект].Владелец.Тип());
				
				
				СобратьСписокXDTO(СтрокаДерева, СборкаXDTO, ЗначенияФормы);  
				
				
				СборкаXDTO.Добавить(Форма, ПространствоИмен, Имя, ОбъектСписокXDTO);
				Возврат;
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(СтрокаДерева[ПолеОбъект]) = Тип("ОбъектXDTO") Тогда
				
			Если СборкаXDTO.Свойства().Получить(СтрокаДерева[ПолеСвойство].Имя) = Неопределено Тогда
				Форма = СтрокаДерева[ПолеСвойство].Форма;
				ПространствоИмен = СтрокаДерева[ПолеСвойство].URIПространстваИмен;
				Имя = СтрокаДерева[ПолеСвойство].Имя;
				Значение = ФабрикаXDTO.Создать(СтрокаДерева[ПолеОбъект].Тип());
				СборкаXDTO.Добавить(Форма, ПространствоИмен, Имя, Значение);
			Иначе
				СборкаXDTO.Установить(СтрокаДерева[ПолеСвойство].Имя, СтрокаДерева[ПолеОбъект]); 
			КонецЕсли;
			
		Иначе
			Если СтрокаДерева[ПолеСвойство] = Неопределено Тогда
				
				Если СтрокаДерева["ОбъектСвойство"] <> Неопределено Тогда
					ПолеСвойство = "ОбъектСвойство";
				ИначеЕсли СтрокаДерева["ВерсияXML1Свойство"] <> Неопределено Тогда
					ПолеСвойство = "ВерсияXML1Свойство";
				ИначеЕсли СтрокаДерева["ВерсияXML2Свойство"] <> Неопределено Тогда
					ПолеСвойство = "ВерсияXML2Свойство";
				КонецЕсли;
			КонецЕсли;	
				
			Если СборкаXDTO.Свойства().Получить(СтрокаДерева[ПолеСвойство].Имя) = Неопределено Тогда
				Форма = СтрокаДерева[ПолеСвойство].Форма;
				ПространствоИмен = СтрокаДерева[ПолеСвойство].URIПространстваИмен;
				Имя = СтрокаДерева[ПолеСвойство].Имя;
				
				Если ТипЗнч(СтрокаДерева[ПолеОбъект]) = Тип("Строка") Или СтрокаДерева[ПолеОбъект] = Неопределено Тогда
					ТипЗначенияXML = "string";
				ИначеЕсли ТипЗнч(СтрокаДерева[ПолеОбъект]) = Тип("Булево") Тогда
					ТипЗначенияXML = "boolean";
				Иначе
					ТипЗначенияXML = "decimal";
				КонецЕсли;
				
				ТипЗначения = ФабрикаXDTO.Тип("http://www.w3.org/2001/XMLSchema", ТипЗначенияXML);
				ЗначениеXDTO = ФабрикаXDTO.Создать(ТипЗначения, СтрокаДерева[ПолеОбъект]);
				СборкаXDTO.Добавить(Форма, ПространствоИмен, Имя, ЗначениеXDTO);
				
				
			Иначе
				СборкаXDTO.Установить(СтрокаДерева[ПолеСвойство].Имя, СтрокаДерева[ПолеОбъект]); 
			КонецЕсли;
		КонецЕсли;	
		
			
		СобратьXDTOРекурсивно(СтрокаДерева, СборкаXDTO.ПолучитьXDTO(СтрокаДерева[ПолеСвойство].Имя), ЗначенияФормы);
			
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СобратьСписокXDTO(СтрокаДерева, СписокXDTO, СтрокаДереваФормы)
	
	ЭлементыФормыСписка = СтрокаДереваФормы.ПолучитьЭлементы();
	Для Каждого СтрокаСписка Из СтрокаДерева.Строки Цикл
					
		
		ЗначениеФормыСписка = ЭлементыФормыСписка[СтрокаДерева.Строки.Индекс(СтрокаСписка)];
		Если ЗначениеФормыСписка.ВзятьИзОбъекта Тогда

			ПолеОбъект = "Объект";
			ПолеСвойство = "ОбъектСвойство";
			
		КонецЕсли;
		
		Если ЗначениеФормыСписка.ВзятьИзВерсии1 Тогда	
			
			ПолеОбъект = "ВерсияXML1";
			ПолеСвойство = "ВерсияXML1Свойство";
			
		КонецЕсли;

		Если ЗначениеФормыСписка.ВзятьИзВерсии2 Тогда	
			
			ПолеОбъект = "ВерсияXML2";
			ПолеСвойство = "ВерсияXML2Свойство";
			
		КонецЕсли;
		
		ЭлементСпискаXDTO = ФабрикаXDTO.Создать(СтрокаСписка[ПолеОбъект].Тип());
		СобратьXDTOРекурсивно(СтрокаСписка, ЭлементСпискаXDTO, ЗначениеФормыСписка);
		
		Форма = СтрокаСписка[ПолеСвойство].Форма;
		ПространствоИмен = СтрокаСписка[ПолеСвойство].URIПространстваИмен;
		ЛокальноеИмя = СтрокаСписка[ПолеСвойство].ЛокальноеИмя;
		
		СписокXDTO.Добавить(Форма, ПространствоИмен, ЛокальноеИмя, ЭлементСпискаXDTO);
	КонецЦикла;
	
	
КонецПроцедуры

	
#КонецОбласти