#!/bin/sh

echo "****** VM_after_build.sh\n"

echo "BRANCH_NAME=${BRANCH_NAME}"
echo     "For a multibranch project, this will be set to the name of the branch being built, for example in case you wish to deploy to production from master but not from feature branches; if corresponding to some kind of change request, the name is generally arbitrary (refer to CHANGE_ID and CHANGE_TARGET).\n"

echo "CHANGE_ID=${CHANGE_ID}"
echo     "For a multibranch project corresponding to some kind of change request, this will be set to the change ID, such as a pull request number, if supported; else unset.\n"

echo "CHANGE_URL=${CHANGE_URL}"
echo     "For a multibranch project corresponding to some kind of change request, this will be set to the change URL, if supported; else unset.\n"

echo "CHANGE_TITLE=${CHANGE_TITLE}"
echo     "For a multibranch project corresponding to some kind of change request, this will be set to the title of the change, if supported; else unset.\n"

echo "CHANGE_AUTHOR=${CHANGE_AUTHOR}"
echo     "For a multibranch project corresponding to some kind of change request, this will be set to the username of the author of the proposed change, if supported; else unset.\n"

echo "CHANGE_AUTHOR_DISPLAY_NAME=${CHANGE_AUTHOR_DISPLAY_NAME}"
echo     "For a multibranch project corresponding to some kind of change request, this will be set to the human name of the author, if supported; else unset.\n"

echo "CHANGE_AUTHOR_EMAIL=${CHANGE_AUTHOR_EMAIL}"
echo     "For a multibranch project corresponding to some kind of change request, this will be set to the email address of the author, if supported; else unset.\n"

echo "CHANGE_TARGET=${CHANGE_TARGET}"
echo     "For a multibranch project corresponding to some kind of change request, this will be set to the target or base branch to which the change could be merged, if supported; else unset.\n"

echo "BUILD_NUMBER=${BUILD_NUMBER}"
echo     "The current build number, such as \"153\"\n"

echo "BUILD_ID=${BUILD_ID}"
echo     "The current build ID, identical to BUILD_NUMBER for builds created in 1.597+, but a YYYY-MM-DD_hh-mm-ss timestamp for older builds\n"

echo "BUILD_DISPLAY_NAME=${BUILD_DISPLAY_NAME}"
echo     "The display name of the current build, which is something like \"#153\" by default.\n"

echo "JOB_NAME=${JOB_NAME}"
echo     "Name of the project of this build, such as "foo" or \"foo/bar\".\n"

echo "JOB_BASE_NAME=${JOB_BASE_NAME}"
echo     "Short Name of the project of this build stripping off folder paths, such as \"foo\" for \"bar/foo\".\n"

echo "BUILD_TAG=${BUILD_TAG}"
echo     "String of \"jenkins-\${JOB_NAME\}-\${BUILD_NUMBER}\". All forward slashes (\"/\") in the JOB_NAME are replaced with dashes (\"-\"). Convenient to put into a resource file, a jar file, etc for easier identification.\n"

echo "EXECUTOR_NUMBER=${EXECUTOR_NUMBER}"
echo     "The unique number that identifies the current executor (among executors of the same machine) that’s carrying out this build. This is the number you see in the \"build executor status\", except that the number starts from 0, not 1.\n"

echo "NODE_NAME=${NODE_NAME}"
echo     "Name of the agent if the build is on an agent, or \"master\" if run on master\n"

echo "NODE_LABELS=${NODE_LABELS}"
echo     "Whitespace-separated list of labels that the node is assigned.\n"

echo "WORKSPACE=${WORKSPACE}"
echo     "The absolute path of the directory assigned to the build as a workspace.\n"

echo "JENKINS_HOME=${JENKINS_HOME}"
echo     "The absolute path of the directory assigned on the master node for Jenkins to store data.\n"

echo "JENKINS_URL=${JENKINS_URL}"
echo     "Full URL of Jenkins, like http://server:port/jenkins/ (note: only available if Jenkins URL set in system configuration)\n"

echo "BUILD_URL=${BUILD_URL}"
echo     "Full URL of this build, like http://server:port/jenkins/job/foo/15/ (Jenkins URL must be set)\n"

echo "JOB_URL=${JOB_URL}"
echo     "Full URL of this job, like http://server:port/jenkins/job/foo/ (Jenkins URL must be set)\n"

echo "GIT_COMMIT=${GIT_COMMIT}"
echo     "The commit hash being checked out.\n"

echo "GIT_PREVIOUS_COMMIT=${GIT_PREVIOUS_COMMIT}"
echo     "The hash of the commit last built on this branch, if any.\n"

echo "GIT_PREVIOUS_SUCCESSFUL_COMMIT=${GIT_PREVIOUS_SUCCESSFUL_COMMIT}"
echo     "The hash of the commit last successfully built on this branch, if any.\n"

echo "GIT_BRANCH=${GIT_BRANCH}"
echo     "The remote branch name, if any.\n"

echo "GIT_LOCAL_BRANCH=${GIT_LOCAL_BRANCH}"
echo     "The local branch name being checked out, if applicable.\n"

echo "GIT_URL=${GIT_URL}"
echo     "The remote URL. If there are multiple, will be GIT_URL_1, GIT_URL_2, etc.\n"

echo "GIT_COMMITTER_NAME=${GIT_COMMITTER_NAME}"
echo     "The configured Git committer name, if any.\n"

echo "GIT_AUTHOR_NAME=${GIT_AUTHOR_NAME}"
echo     "The configured Git author name, if any.\n"

echo "GIT_COMMITTER_EMAIL=${GIT_COMMITTER_EMAIL}"
echo     "The configured Git committer email, if any.\n"

echo "GIT_AUTHOR_EMAIL=${GIT_AUTHOR_EMAIL}"
echo     "The configured Git author email, if any.\n"

echo "SVN_REVISION=${SVN_REVISION}"
echo     "Subversion revision number that's currently checked out to the workspace, such as \"12345\"\n"

echo "SVN_URL=${SVN_URL}"
echo     "Subversion URL that's currently checked out to the workspace.\n"
