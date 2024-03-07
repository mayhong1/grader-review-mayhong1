CPATH=".;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar"

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

if [[ $# -eq 0 ]]
then
    echo "No arguments provided."
    exit 1
fi

git clone $1 student-submission 2> git-output.txt
if [[ $? -ne 0 ]]
then
    echo "Error cloning repo, Please check link"
    exit 1
fi


if [[ -f student-submission/TestListExamples.java ]]
then 
    echo "Missing Necessary Files"
    exit 1
fi

cp TestListExamples.java student-submission/ListExamples.java grading-area
cp -r lib grading-area

cd grading-area
pwd
javac -cp $CPATH *.java 2> error.txt
if [[ $? -ne 0 ]]
then
    echo "Compilation Error(s), Please Fix and Resubmit"
    exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt
# grep "OK (1 Test)" junit-output.txt
if [[ `grep "OK" junit-output.txt` ]]
then
    echo "You passed all test cases! Congrats!"
    exit 0;
fi


lastline=$(cat junit-output.txt | tail -n 2 | head -n 1)
tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
successes=$((tests - failures))
echo "Your score is $successes / $tests"


# echo "Total: ${numbers[0]}, Failures: ${numbers[1]}"

# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests