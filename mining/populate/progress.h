#ifndef INCLUDE_populate_progress_h
#define INCLUDE_populate_progress_h


extern unsigned long long tasksCompleted;
extern volatile bool progressUpdateNeeded;

void displayProgress();
void initializeAlarm();


#endif // !INCLUDE_populate_progress_h
