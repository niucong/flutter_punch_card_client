package com.niucong.punchcardclient;

import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.WindowManager;

import com.alibaba.fastjson.JSON;
import com.bin.david.form.core.SmartTable;
import com.niucong.punchcardclient.db.ScheduleDB;
import com.niucong.punchcardclient.table.Schedule;

import java.util.ArrayList;
import java.util.List;

import androidx.appcompat.app.ActionBar;
import androidx.appcompat.app.AppCompatActivity;

/**
 * 作息表
 */
public class ScheduleActivity extends AppCompatActivity {

    SmartTable<Schedule> table;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        table = new SmartTable<>(this);
        setContentView(table);
//        setContentView(R.layout.activity_schedule);
//        table = findViewById(R.id.schedule_table);

        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setHomeButtonEnabled(true);
            actionBar.setDisplayHomeAsUpEnabled(true);
        }

        WindowManager wm = this.getWindowManager();
        int screenWith = wm.getDefaultDisplay().getWidth();
        table.getConfig().setMinTableWidth(screenWith); //设置最小宽度 屏幕宽度

//        if (LitePal.count(ScheduleDB.class) == 0) {
//            App.showToast("请先刷新作息表");
//        } else {
        refreshScheduleList();
//        }
    }

    private void refreshScheduleList() {
        final List<Schedule> schedules = new ArrayList<>();

        String listData = getIntent().getStringExtra("listData");
        for (ScheduleDB scheduleDB : JSON.parseArray(listData, ScheduleDB.class)) {
            schedules.add(new Schedule(scheduleDB.getTimeRank(), scheduleDB.getSectionName(), scheduleDB.getTime()));
        }

//        String dataPath = getDatabasePath("database.db").getPath();
//        SQLiteDatabase db = SQLiteDatabase.openOrCreateDatabase(dataPath, null);
//        Cursor cur = db.rawQuery(
//                "select * from Schedule", new String[]{});
//        while (cur.moveToNext()) {
//            schedules.add(new Schedule(cur.getString(cur.getColumnIndex("timeRank")),
//                    cur.getString(cur.getColumnIndex("sectionName")),
//                    cur.getString(cur.getColumnIndex("time"))));
//        }
//        cur.close();

        table.setData(schedules);
        table.getConfig().setShowTableTitle(false);
        table.setZoom(true, 2, 0.2f);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        this.getMenuInflater().inflate(R.menu.menu_refresh, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        super.onOptionsItemSelected(item);
        switch (item.getItemId()) {
            case android.R.id.home:
                this.finish();
                break;
            case R.id.action_refresh:

                break;
        }
        return super.onOptionsItemSelected(item);
    }

}
