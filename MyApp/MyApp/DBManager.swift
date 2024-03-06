import Foundation
import SQLite3
class DBManager {
    
    let DB_NAME = "my_db.sqlite"
    let TABLE_NAME = "my_table"
    let COL_ID = "id"
    let COL_TITLE = "name"
    let COL_DATE = "date"
    let COL_DETAIL = "detail"
    let COL_ICON = "icon"
    
    var db : OpaquePointer?
    
//    앱을 실행할 때 수행
    func initDatabase() {
        openDatabase()
        createTable()
        closeDatabase()
    }
    
//    DB 사용 전에 호출
    private func openDatabase() {
        let dbFile = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(DB_NAME)
        
        if sqlite3_open(dbFile.path, &db) == SQLITE_OK {
            print("Successfully Opened")
            print(dbFile)
        } else {
            print("Unable to open DB")
        }
    }
    
//    테이블 생성
    private func createTable() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS \(TABLE_NAME) ( \(COL_ID) INTEGER PRIMARY KEY AUTOINCREMENT,\(COL_TITLE) TEXT,\(COL_DATE) INT32,\(COL_DETAIL) TEXT,\(COL_ICON) TEXT);
        """
        var createTalbeStmt: OpaquePointer?
        
        print ("TABLE SQL: \(createTableString)")
        
        if sqlite3_prepare(db, createTableString, -1, &createTalbeStmt, nil) == SQLITE_OK {
            if sqlite3_step(createTalbeStmt) == SQLITE_DONE {
                print("Successfully Created")
            }
            sqlite3_finalize(createTalbeStmt)
        } else {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Table Error: \(error)")
        }
        
    }
    
//    DB 완료 후 호출 
    private func closeDatabase() {
        if sqlite3_close(db) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Database Close Error: \(errmsg)")
            return
        }
    }
    
//    items 배열에 DB의 내용 전체를 추가
    func readAllData() {
//        샘플이므로 DB 구현 시 주석 처리
//        items.append(TaskDto(id: 1, title: "hello", date: 1625728889, detail: "hi", icon: "clock.png"))
//        items.append(TaskDto(id: 2, title: "안녕하세요", date: 1625728889, detail: "안녕", icon: "cart.png"))
        
        openDatabase()
        
        let sql = "select * from \(TABLE_NAME)"
        
        var queryStmt: OpaquePointer?
        
        if sqlite3_prepare(db, sql, -1, &queryStmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Reading Error : \(errmsg)")
            return
        }
        
        while (sqlite3_step(queryStmt) == SQLITE_ROW) {
            let id = Int(sqlite3_column_int(queryStmt, 0))
            let title = String(cString: sqlite3_column_text(queryStmt, 1))
            let date = sqlite3_column_int(queryStmt, 2)
            let detail = String(cString: sqlite3_column_text(queryStmt, 3))
            let icon = String(cString: sqlite3_column_text(queryStmt, 4))
            
            items.append(TaskDto(id: id, title: title, date: date, detail: detail, icon: icon))
        }
        
        sqlite3_finalize(queryStmt)
        
        closeDatabase()
    }

//    항목 추가
    func insertData(_ title_value: String, _ date_value: Int32,_ detail_value: String,_ icon_value: String) {
        openDatabase()
        
        var insertStmt: OpaquePointer?
        let sql = "insert into \(TABLE_NAME) values (null, ?, ?, ?, ?)"
        
        if sqlite3_prepare_v2(db, sql, -1, &insertStmt, nil) == SQLITE_OK {
            let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
            
            if sqlite3_bind_text(insertStmt, 1, title_value, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Text Binding Failure: \(errmsg)")
                return
            }
            
            if sqlite3_bind_int(insertStmt, 2, date_value) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Text Binding Failure: \(errmsg)")
                return
            }
            
            if sqlite3_bind_text(insertStmt, 3, detail_value, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Text Binding Failure: \(errmsg)")
                return
            }
            if sqlite3_bind_text(insertStmt, 4, icon_value, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Text Binding Failure: \(errmsg)")
                return
            }
            
            if sqlite3_step(insertStmt) == SQLITE_DONE {
                print("Successfully inserted.")
            } else {
                print("insert error")
            }
            sqlite3_finalize(insertStmt)
        } else {
            print("Insert statement is not prepared.")
        }
        
        closeDatabase()
    }
    
// 항목 수정
    func updateData(_ id_value: Int, _ title_value: String, _ detail_value: String) {
        openDatabase()
        
        let query = "update \(TABLE_NAME) set \(COL_TITLE) = ?, \(COL_DETAIL) = ? where \(COL_ID) = ?"
        
        var updateStmt: OpaquePointer?
        
        if sqlite3_prepare(db, query, -1, &updateStmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing update: \(errmsg)")
            return
        }
    
        bindTextParams(updateStmt!, no: 1, param: title_value)
        bindTextParams(updateStmt!, no: 2, param: detail_value)
        bindIntParams(updateStmt!, no: 3, param: id_value)
        
        if sqlite3_step(updateStmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Update Failure: \(errmsg)")
            return
        }
        
        sqlite3_finalize(updateStmt)
        
        closeDatabase()
    }

// 항목 삭제
    func deleteData(_ id_value: Int) {
        openDatabase()
        
        let query = "delete from \(TABLE_NAME) where \(COL_ID) = ?"
        var deleteStmt: OpaquePointer?
        
        if sqlite3_prepare(db, query, -1, &deleteStmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing stmt: \(errmsg)")
            return
        }
        
        bindIntParams(deleteStmt!, no: 1, param: id_value)
        
        if sqlite3_step(deleteStmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Delete Failure: \(errmsg)")
            return
        }
        
        sqlite3_finalize(deleteStmt)
        
        closeDatabase()
    }

    func bindTextParams(_ stmt: OpaquePointer, no: Int, param: String) {
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        if sqlite3_bind_text(stmt, Int32(no), param, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Text Binding Failure: \(errmsg)")
            return
        }
    }

    func bindIntParams(_ stmt: OpaquePointer, no: Int, param: Int) {
        if sqlite3_bind_int(stmt, Int32(no), Int32(param)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Integer Binding Failure: \(errmsg)")
            return
        }
    }
    
    func bindInt32Params(_ stmt: OpaquePointer, no: Int32, param: Int32) {
        if sqlite3_bind_int(stmt, no, param) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Integer Binding Failure: \(errmsg)")
            return
        }
    }

    func dropTable() {
        let query = "drop table if exists \(TABLE_NAME)"
        if sqlite3_exec(db, query, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Drop Error: \(errmsg)")
            return
        }
    }

}
