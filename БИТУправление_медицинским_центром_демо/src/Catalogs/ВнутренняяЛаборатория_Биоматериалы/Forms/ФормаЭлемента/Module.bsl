
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	НастроитьТабличныеЧастиНаКлиенте();	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	НастроитьТабличныеЧастиНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура СопоставлениеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	РаботаСДиалогамиКлиент.ПередНачаломДобавленияВПодчиненныйСписокНаФормеОбъекта(ЭтаФорма, Элемент, Отказ); 
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НастроитьТабличныеЧастиНаКлиенте()
	РаботаСФормамиКлиент.УстановитьОтборСписка("Биоматериал", Объект.Ссылка, Сопоставление);
КонецПроцедуры

#КонецОбласти
