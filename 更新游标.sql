-- 定义游标
declare m_cursor cursor scroll for
select ID from Product_Library_Bill where int_Bill_type=80 or int_Bill_type=90 
for update
-- 打开游标
open m_cursor
declare   @ID int
declare @Member_ID int=0
declare @OrderNm_ID int=0
--填充数据
fetch next from m_cursor into @ID 
--假如检索到了数据，才处理
while @@FETCH_STATUS=0
begin
    select @OrderNm_ID=OrderNm_ID from Product_Library_Bill where ID=@ID
    select @Member_ID=Member_ID from OrderNm where ID=@OrderNm_ID
    update Product_Library_Bill set member_ID=@Member_ID  where ID=@ID
    update Product_Library_Bill_Desc set member_ID=@Member_ID  where Product_Library_Bill_ID=@ID
    --填充下一条数据
    fetch next from m_cursor into @ID
end
-- 关闭游标
close m_cursor
--释放游标
deallocate m_cursor