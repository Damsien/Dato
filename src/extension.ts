import * as vscode from 'vscode';
import * as os from 'os';


export function activate(context: vscode.ExtensionContext) {

	/* -- USER PLATFORM -- */
	const PLATFORM = os.platform();

	/* -- PATH OPTION -- */
	const WORKDIR = PLATFORM == 'win32' ? '%USERPROFILE%\\.vscode\\extensions\\dato' : "$HOME/.vscode/extensions/dato";
	const PS_WORKDIR = "$env:USERPROFILE\\.vscode\\extensions\\dato\\interpreteur\\dist"
	const SEPARATOR = PLATFORM == 'win32' ? '\\' : '/'
	const INTPRDIR = `${WORKDIR}${SEPARATOR}interpreteur`;
	const INSTALL = `${WORKDIR}${SEPARATOR}install`;
	const COMPILE = `${INTPRDIR}${SEPARATOR}compile`;
	const INTRPRE = `src${SEPARATOR}compiler${SEPARATOR}test.adb`;
	const DIST = `${INTPRDIR}${SEPARATOR}dist${SEPARATOR}test`;

	
	const statusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left,1000);
	statusBarItem.command = 'dato.buildAndRun';
	statusBarItem.name = "Dato run";
	statusBarItem.text = "$(debug-start) Dato run";
	statusBarItem.tooltip = "Run and Build a Dato algorithm";
	context.subscriptions.push(statusBarItem);

	console.log("test");
	const errorColor = new vscode.ThemeColor('superstatus.error');
	console.log(errorColor);


	// Build and run
	context.subscriptions.push(
		vscode.commands.registerCommand("dato.buildAndRun", () => {

			statusBarItem.show();

			if (true) {

				const filePath = PLATFORM == 'win32' ? vscode.window.activeTextEditor?.document.uri.fsPath : vscode.window.activeTextEditor?.document.uri.path;

				const options: vscode.OpenDialogOptions = {
					canSelectMany: false,
					openLabel: 'Open',
					filters: {
					   'Text files': ['txt'],
					   'All files': ['*']
				   }
			   };
			   

				switch (PLATFORM) {
					case "win32":
						openwithWindows(filePath);
						break;
					case "darwin":
						openwithMac();
						break;
					default:
						openwithLinux(filePath);
						break;
				}
			}

			// Ouvrir un processus fils
			function checkGnat() : Promise<Status> {

				return exec(`gnatmake -v`, "Gnat not found");

			}


//			>>>>>>>>>>>>>>>>>>>>>>>>>	GNAT INSTALLATION   <<<<<<<<<<<<<<<<<<<<<<<<<<<<<

			async function installGnatForLinux() : Promise<Status> {

				const password = await vscode.window.showInputBox({
					password: true,
					placeHolder: "Root Password",
					prompt: "GNAT Missing ! Please enter your password to install it.",
				  });

				  	vscode.window.showInformationMessage("Installing gnat package...");

					return exec(` echo "${password}" | sudo -S ${INSTALL}${SEPARATOR}linux.sh`,"Incorrect password");
						
			}

			async function installGnatForWindows() : Promise<Status> {

				let status;

				/* Check for admin rights */
				status = await exec(`setx /M path "%path%"`, "Visual Studio Code must be run in privileged mode");
				if(!status.state) return status;

				console.log("Status : "+status.state);
				status = null;

				vscode.window.showInformationMessage("Downloading binaries...");

				/* Download Gnat */
				status = await exec(`cd ${INSTALL} & windows.bat`, "Failed to get Gnat file online");
				if(!status.state) return status;

				console.log("Status : "+status.state);
				status = null

				vscode.window.showInformationMessage("Waiting for user install...");
				
				/* Install Gnat */
				status = await exec(`cd ${INSTALL} & gnat.exe & del gnat.exe"`,"An error as occured while processing");
				if(!status.state) return status;

				console.log("Status : "+status.state);
				status = null
				
				/* Check for PATH variable */
				status = await exec(`setx /M path "C:\\GNAT\\2021\\bin;%path% & gnatmake -v`,"gnatmake still not found. Have you changed the default location folder? If so, add the current location to PATH system variable.");
				
				console.log("Status : "+status.state);

				/* Restart Visual Studio Code */
				let response = await vscode.window.showInformationMessage("Visual must be restarted to apply modifications");
				
				return status;
			}


//			>>>>>>>>>>>>>>>>>>>>>>>>>	GNAT COMPILATION    <<<<<<<<<<<<<<<<<<<<<<<<<<<<<


			async function compileFileForLinux() : Promise<Status> {
				
				return exec(`cd ${INTPRDIR} ; ${COMPILE} ${INTRPRE}`, "Error while compiling the program");

			}

			async function compileFileForWindows() : Promise<Status> {
				
				return exec(`cd ${INTPRDIR} & compile.bat ${INTRPRE}`, "Unknown error while compiling the program");

			}

//			>>>>>>>>>>>>>>>>>>>>>>>>>	GNAT EXECUTION    <<<<<<<<<<<<<<<<<<<<<<<<<<<<<

			async function execDatoForLinux(filePath : string | undefined) {
				
				let res = await exec(`${DIST} ${filePath} > ${WORKDIR}/temp`, "Unexpected error");
				if(res.state) {
					if(vscode.window.terminals.length > 0) {
						const terminal = vscode.window.terminals[0];
						terminal.show();
						terminal.sendText(`cat ${WORKDIR}/temp`);
						terminal.sendText(`rm -f ${WORKDIR}/temp`);
					}
				}
				return res.state;
			}

			async function execDatoForWindows(filePath : string | undefined) {
				
				let res = await exec(`${DIST}.exe ${filePath} > ${WORKDIR}\\temp`,  "Unexpected error");
				if(res.state) {
					if(vscode.window.terminals.length > 0) {
						const terminal = vscode.window.terminals[0];
						terminal.show();
						terminal.sendText(`$oldLocation=$(Split-Path -Path $pwd) ; cd ${PS_WORKDIR} ; .\\test.exe ${filePath} ; cd $oldLocation ; `);
					}
				}
				return res.state;
			}



			async function openwithLinux(filePath : string | undefined) {

				let installed = await checkGnat();

				if (!installed) {
					let response = await vscode.window.showInformationMessage("Ada is not installed on your system.\n Do you want to install it?","Yes","No");
					if(response == "No") return;
					let installationSucces = await installGnatForLinux();
					if(!installationSucces.state) vscode.window.showInformationMessage(installationSucces.msg ? installationSucces.msg : "");
					return;
				}

				let s = await execDatoForLinux(filePath);
				if (!s) {
					let compilationSucces = await compileFileForLinux();
					if(!compilationSucces.state) vscode.window.showInformationMessage(compilationSucces.msg ? compilationSucces.msg : "");
					s = await execDatoForLinux(filePath);
				}

				if(!s) {
					if(vscode.window.terminals.length > 0) {
						const terminal = vscode.window.terminals[0];
						terminal.show();
						terminal.sendText("# Unable to execute the program. Abort.");
					}
				}
				 

			}

			async function openwithWindows(filePath : string | undefined) {

				let installed = await checkGnat();

				if (!installed.state) {
					let response = await vscode.window.showInformationMessage("Ada is not installed on your system.\n Do you want to install it?","Yes","No");
					if(response == "No" || response == undefined) return;
					let installationSucces = await installGnatForWindows();
					if(!installationSucces.state) {
						vscode.window.showInformationMessage(installationSucces.msg ? installationSucces.msg : "") 
					}
					return;
					
				}

				console.log("Trying to exec...")
				let s = await execDatoForWindows(filePath);
				if (!s) {
					console.log("Compiling...")
					await compileFileForWindows();
					console.log("Retrying...")
					s = await execDatoForWindows(filePath);
				}

				if(!s) {
					if(vscode.window.terminals.length > 0) {
						const terminal = vscode.window.terminals[0];
						terminal.show();
						terminal.sendText("# Unable to execute the program. Abort.");
					}
				}

				

			}

			async function openwithMac() {

			}

			//vscode.window.showInformationMessage("Compilation du fichier...");

		})
	);

	context.subscriptions.push(statusBarItem);

}

export class Status {

	state : boolean;
	msg? : string;

	constructor(state : boolean, msg? : string) {
		this.state = state;
		this.msg = msg;
	}
}

export function exec(command: string, error : string) : Promise<Status> {

	const cp = require('child_process');

	return new Promise((resolve) => {

		cp.exec(command, (err: any, stdout: any, stderr: any) => {
			if (err) { console.log(err);resolve(new Status(false,error)); } else { resolve(new Status(true))}});

	})

}



// this method is called when your extension is deactivated
export function deactivate() { }
