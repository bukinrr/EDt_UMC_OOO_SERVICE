#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("Документ.ПрохождениеМедосмотра.Форма.ДокументыВыполненияМедосмотра",
				 Новый Структура("ПрохождениеМедОсмотра", ПараметрКоманды),,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
 КонецПроцедуры
			 
#КонецОбласти
