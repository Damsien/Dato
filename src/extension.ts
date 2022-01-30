import * as vscode from 'vscode';
import * as os from 'os';


export function activate(context: vscode.ExtensionContext) {

	const cp = require('child_process');

	/* -- USER PLATFORM -- */
	const PLATFORM = os.platform();

	/* -- PATH OPTION -- */
	const WORKDIR = "$HOME/.vscode/extensions/dato"; //const FOLDER = "$HOME/.vscode/extensions";
	const INTPRDIR = `${WORKDIR}/interpreteur`;
	const INSTALL = `${INTPRDIR}/install`;
	const COMPILE = `${WORKDIR}/compile`;
	const INTRPRE = `src/compiler/test.adb`;
	const DIST = `${INTPRDIR}/dist/test`;

	
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

				const filePath = vscode.window.activeTextEditor?.document.uri.path;

				console.log("Path : " + filePath);

				switch (PLATFORM) {
					case "win32":
						openwithWindows();
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
			function checkGnat() {

				return new Promise<Boolean>((resolve) => {

					cp.exec(`gnatmake -v`, (err: any, stdout: any, stderr: any) => {
						if (err) { resolve(false); } else { resolve(true); }

					});

				});

			}

			async function installGnatForLinux() {

				const password = await vscode.window.showInputBox({
					password: true,
					placeHolder: "Root Password",
					prompt: "GNAT Missing ! Please enter your password to install it.",
				  });


					return new Promise<Boolean>((resolve) => {
						 cp.exec(` echo "${password}" | sudo -S ${INSTALL}/linux.sh`, (err: any, stdout: any, stderr: any) => {
						if (err) { resolve(false); } else { resolve(true); }
					});

				});
			}

			async function execDatoForLinux(filePath : string | undefined) {

				console.log(vscode.window.terminals.length);
				
				return new Promise<Boolean>((resolve) => {
					cp.exec(`${DIST} ${filePath} > ${WORKDIR}/temp`, (err: any, stdout: any, stderr: any) => {
				   if (err) { 
					   console.log(err);
					   resolve(false); 
					} else { 
						
						if(vscode.window.terminals.length > 0) {
							const terminal = vscode.window.terminals[0];
							terminal.show();
							terminal.sendText(`cat ${WORKDIR}/temp`);
							terminal.sendText(`rm -f ${WORKDIR}/temp`);
						}

						resolve(true); }
				});
				});
			}

			async function compileFileForLinux() {
				
				return new Promise<Boolean>((resolve) => {
					cp.exec(`cd ${WORKDIR}/interpreteur ; pwd ; ${COMPILE} ${INTRPRE}`, (err: any, stdout: any, stderr: any) => {
				   if (err) { 
					resolve(false); } else { resolve(true); }
			   });
			});

			}


			async function openwithLinux(filePath : string | undefined) {

				console.log("Open with Linux :");

				let installed = await checkGnat();

				if (!installed) {
					await installGnatForLinux();
				}

				let s = await execDatoForLinux(filePath);
				if (!s) {
					await compileFileForLinux();
					
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

			async function openwithWindows() {

			}

			async function openwithMac() {

			}

			//vscode.window.showInformationMessage("Compilation du fichier...");

		})
	);

	context.subscriptions.push(statusBarItem);
	setTimeout(() => {statusBarItem.show();},5000);

}



// this method is called when your extension is deactivated
export function deactivate() { }
