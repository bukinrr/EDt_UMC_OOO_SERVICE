
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Если ЕстьПраво() Тогда
		ОткрытьФорму("РегистрСведений.ОбращенияВТехПоддержкуБИТ.Форма.ПоддержкаДополнительнаяИнформацияОбращений", , ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	Иначе
		ПоказатьПредупреждение(, "Недостаточно прав доступа");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ЕстьПраво()
	
	Возврат ПравоДоступа("Редактирование", Метаданные.Константы.ПоддержкаДополнительнаяИнформацияОбращений);
	
КонецФункции
