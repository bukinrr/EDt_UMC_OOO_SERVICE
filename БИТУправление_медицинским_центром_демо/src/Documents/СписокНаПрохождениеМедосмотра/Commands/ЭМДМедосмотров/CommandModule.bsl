#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОткрытьФорму("Документ.СписокНаПрохождениеМедосмотра.Форма.ЭМДМедосмотров", Новый Структура("СПМО", ПараметрКоманды),,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

#КонецОбласти
