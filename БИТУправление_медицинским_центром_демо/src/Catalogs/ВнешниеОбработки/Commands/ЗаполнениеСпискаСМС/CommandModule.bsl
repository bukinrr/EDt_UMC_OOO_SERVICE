#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("Отбор", Новый Структура("ВидОбработки", ПредопределенноеЗначение("Перечисление.ВидыДополнительныхВнешнихОбработок.ЗаполнениеСпискаСМСРассылки")));
	ОткрытьФорму("Справочник.ВнешниеОбработки.ФормаСписка",ПараметрыФормы,,ПараметрыФормы.Отбор.ВидОбработки);
КонецПроцедуры

#КонецОбласти
