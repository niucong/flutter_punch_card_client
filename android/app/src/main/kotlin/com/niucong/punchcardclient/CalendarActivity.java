package com.niucong.punchcardclient;

import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.view.MenuItem;

import com.bin.david.form.core.SmartTable;
import com.niucong.punchcardclient.table.Calendar;

import java.util.ArrayList;
import java.util.List;

import androidx.appcompat.app.ActionBar;
import androidx.appcompat.app.AppCompatActivity;

/**
 * 校历
 */
public class CalendarActivity extends AppCompatActivity {

    SmartTable<Calendar> table;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        table = new SmartTable<>(this);
        setContentView(table);

        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setHomeButtonEnabled(true);
            actionBar.setDisplayHomeAsUpEnabled(true);
        }
        refreshCalendarList();
    }

    private void refreshCalendarList() {
        final List<Calendar> calendars = new ArrayList<>();
        String dataPath = getDatabasePath("database.db").getPath();
        SQLiteDatabase db = SQLiteDatabase.openOrCreateDatabase(dataPath, null);
        Cursor cur = db.rawQuery(
                "select * from Calendar", new String[]{});
        while (cur.moveToNext()) {
            calendars.add(new Calendar(cur.getString(cur.getColumnIndex("session")),
                    cur.getString(cur.getColumnIndex("weekly")),
                    cur.getString(cur.getColumnIndex("month")),
                    cur.getString(cur.getColumnIndex("monday")),
                    cur.getString(cur.getColumnIndex("tuesday")),
                    cur.getString(cur.getColumnIndex("wednesday")),
                    cur.getString(cur.getColumnIndex("thursday")),
                    cur.getString(cur.getColumnIndex("friday")),
                    cur.getString(cur.getColumnIndex("saturday")),
                    cur.getString(cur.getColumnIndex("sunday"))));
        }
        cur.close();

        table.setData(calendars);
        table.getConfig().setShowTableTitle(false);
        table.setZoom(true, 2, 0.2f);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        super.onOptionsItemSelected(item);
        switch (item.getItemId()) {
            case android.R.id.home:
                this.finish();
                break;
        }
        return super.onOptionsItemSelected(item);
    }

}
