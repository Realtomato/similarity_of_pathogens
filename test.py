import openpyxl
wb = openpyxl.Workbook()
ws = wb.active

ws.append([1,2,3])
wb.save('/home/chenxufan/test/CRP/idseq_script/out.xlsx')