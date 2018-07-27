/* dB.'s

		//////      //      //   ///        //
		//   ///     //    //    // //      //
		//     ///    //  //     //   //    //
		//      //      //       //     //  //
		//      //      //       //      // //
		//     //       //       //        ///
		//    //        //       //         //
		//////          //       //         //

			      ||- CREDITS -||
Special Thanks to -
SAMP Team - samp (duh?)
Y_Less - sscanf
Ingonito - streamer
Zeex - ZCMD

*/

// Includes

#include <a_samp>
#include <zcmd>
#include <streamer>
#include <sscanf2>

//--------------------------------------------------------------//

//////////////////////////////// DEFINES ///////////////////////////////////////
#define MAX_DYN				500
#define MAX_DYNCP			500
#define MAX_3DDYNTEXT       8
#define DIALOG_DYNPICKINT   3504
#define DIALOG_DYNPICKVW	3505
#define DIALOG_DYNPICKUP	3502
#define DIALOG_DYNMAIN      3503

new EditDynID[MAX_PLAYERS];

enum dynenum
{
	Pickup,
	bool:used = false,
	type,
	pid,
	Float:x,
	Float:y,
	Float:z,
	Float:dynx,
	Float:dyny,
	Float:dynz,
	inter,
	vw
}

new Dyn[MAX_DYN][dynenum];

enum dyncp
{
	CP,
	bool:cpused,
	Float:cpdynx,
	Float:cpdyny,
	Float:cpdynz,
	cpinter,
	cpvw
}

enum Text3D:Textenum
{
	txtx,
	txty,
	txtz,
	Text3D:text1,
	Text3D:text2,
	Text3D:text3,
	Text3D:text4,
	Text3D:text5,
	Text3D:text6,
	Text3D:text7,
	Text3D:text8,
	cnt1,
	cnt2,
	cnt3,
	cnt4,
	cnt5,
	cnt6,
	cnt7,
	cnt8
}

new DynCP[MAX_DYNCP][dyncp];
new Text3D:Text[MAX_3DDYNTEXT][Text3D:Textenum];

main()
{
	printf("Don't worry, its just the main() function...");
	return 1;
}

public OnGameModeInit()
{
	printf("--------- Dynamic Pickups And CPs Loaded ----------\n");
	SetGameModeText("Dynamic");
	AddPlayerClass(85, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	for(new i;i > MAX_3DDYNTEXT;i++)
	{
		Text[i][text1] = Text3D:-1;
		Text[i][text2] = Text3D:-1;
		Text[i][text3] = Text3D:-1;
		Text[i][text4] = Text3D:-1;
		Text[i][text5] = Text3D:-1;
		Text[i][text6] = Text3D:-1;
		Text[i][text7] = Text3D:-1;
		Text[i][text8] = Text3D:-1;
	}
	return 1;
}

public OnGameModeExit()
{
	printf("--------- Dynamic Pickups And CPs Unloaded ----------\n");
	return 1;
}

///////////////////////// FUNCTIONS ////////////////////////////////////////////
forward CreateDyn(playerid, id, Float:pox, Float:poy, Float:poz);
public CreateDyn(playerid, id, Float:pox, Float:poy, Float:poz)
{
	new str[500];
	format(str, sizeof(str), "{dbdbdb}[DYN] BLANK! ur pid %d, loc - %f %f %f .", id, pox, poy, poz);
	SendClientMessage(playerid, -1, str);
	return 1;
}

stock DestroyDyn(playerid, id)
{
	if(Dyn[id][used] == true)
	{
	    Dyn[id][used] = false;
	    Dyn[id][dynx] = -1;
	    Dyn[id][dyny] = -1;
	    Dyn[id][dynz] = -1;
	    Dyn[id][type] = -1;
	    Dyn[id][inter] = -1;
	    Dyn[id][vw] = -1;
	    DestroyDynamicPickup(Dyn[id][Pickup]);
	    DestroyDynamic3DTextLabel(Text3D:Text[id][text1]);
	    DestroyDynamic3DTextLabel(Text3D:Text[id][text2]);
	    DestroyDynamic3DTextLabel(Text3D:Text[id][text3]);
	    DestroyDynamic3DTextLabel(Text3D:Text[id][text4]);
	    DestroyDynamic3DTextLabel(Text3D:Text[id][text5]);
	    DestroyDynamic3DTextLabel(Text3D:Text[id][text6]);
	    DestroyDynamic3DTextLabel(Text3D:Text[id][text7]);
	    DestroyDynamic3DTextLabel(Text3D:Text[id][text8]);
		SendClientMessage(playerid, -1, "{dbdbdb}[DYN] Dyn Pickup Destroy.");
	}
	return 1;
}

stock CreateDynCP(playerid, posx, posy, posz)
{
	for(new i;i > MAX_DYN;i++)
	{
		if(DynCP[i][cpused] == false)
		{
			DynCP[i][cpused] = true;
			DynCP[i][CP] = CreateDynamicCP(posx, posy, posz, 5.0);
			DynCP[i][cpdynx] = posx;
			DynCP[i][cpdyny] = posy;
			DynCP[i][cpdynz] = posz;
			SendClientMessage(playerid, -1, "{dbdbdb}[DYNCP] Created a Dyn-CP. Edit it with /editdyncp.");
		}
	}
	return 1;
}

// Commands... Like srsly just cmds.. //////////////////////////////////////////
CMD:createdyn(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
		if(IsPlayerAdmin(playerid)) //Change to PlayerInfo[playerid][Admin] >= 6
		{
			SendClientMessage(playerid, -1, "{dbdbdb}[DYN] Sscanf Passed.");
			new Float:pos[3];
			GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
			for(new i;i > MAX_DYN;i++)
			{
				if(Dyn[i][used] == false)
				{
					SendClientMessage(playerid, -1, "{dbdbdb}[DYN] Loop Passed.");
					Dyn[i][used] = true;
					new str[250];
					format(str, sizeof(str), "{dbdbdb}[DYNAMIC] Created a Dyn-Pickup with id %d", i);
					SendClientMessage(playerid, -1, str);
		      	    SendClientMessage(playerid, -1, "{dbdbdb}[DYN] 1st Check (Sendclientmsgs).");
					Dyn[i][x] = pos[0];
					Dyn[i][y] = pos[1];
					Dyn[i][z] = pos[2];
					Dyn[i][Pickup] = CreateDynamicPickup(2000, 1, Float:pos[0], Float:pos[1], Float:pos[2]);
					Text[i][text1] = CreateDynamic3DTextLabel("[Dyn Pickup]", 0xFFFF00FF, Float:pos[0], Float:pos[1], Float:pos[2] + 1.0, 20.0);
				}
			}
		}
		else
		{
		    SendClientMessage(playerid, -1, "{dbdbdb}[DYNAMIC] You are not Authorised to use this command.");
		}
	}
	return 1;
}

CMD:destroydyn(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
		if(IsPlayerAdmin(playerid)) // Change to PlayerInfo[playerid][Admin] >= 6
		{
		    new id;
			if(sscanf(params, "d", id))
			{
			    return SendClientMessage(playerid, -1, "{dbdbdb}[USAGE] destroydyn <dyn id> ");
			}
			else
			{
				DestroyDyn(playerid, id);
			}
		}
		else
		{
			SendClientMessage(playerid, -1, "{dbdbdb}[DYNAMIC] You are not Authorised to use this command.");
		}
	}
	return 1;
}

CMD:editdyn(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
		if(IsPlayerAdmin(playerid))
		{
			new dynid;
			if(sscanf(params, "d", dynid))
			{
				return SendClientMessage(playerid, -1, "{dbdbdb}[USAGE] Editdyn <id> .");
			}
			else
			{
				ShowPlayerDialog(playerid, DIALOG_DYNMAIN, DIALOG_STYLE_LIST, "Dyn Pickup", "Teleport Co Ordinates\nInterior\nVirtual World\nPickup Co Ordinates\n Pickup Type\n\nType", "Ok", "Cancel");
                SendClientMessage(playerid, -1, "{dbdbdb}[DYN] You are now Editing Dynamic Pickup.");
                EditDynID[playerid] = dynid;
			}
		}
		else
		{
			SendClientMessage(playerid, -1, "{dbdbdb}[DYNAMIC] You are not Authorised to use this command.");
		}
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(dialogid == DIALOG_DYNMAIN)
	    {
 			new id = EditDynID[playerid];
			switch(listitem)
			{
			    case 0:
   				{
					new Float:pos[3];
					GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
					new str[500];
					format(str, sizeof(str), "{dbdbdb}[DYN] Pickup Teleport Location Changed to %d %d %d.", pos[0], pos[1], pos[2]);
					SendClientMessage(playerid, -1, str);
					Dyn[id][dynx] = pos[0];
					Dyn[id][dyny] = pos[1];
                    Dyn[id][dynz] = pos[2];
					Dyn[id][type] = 1;
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_DYNPICKINT, DIALOG_STYLE_INPUT, "Pickup Inerior", "Enter Dyn Pickup's Interior.", "Ok", "Cancel");
				}
	            case 2:
	            {
	            	ShowPlayerDialog(playerid, DIALOG_DYNPICKVW, DIALOG_STYLE_INPUT, "Pickup VW", "Enter Dyn Pickup's Virtual World.", "Ok", "Cancel");
				}
				case 3:
				{
					if(IsValidDynamicPickup(Dyn[id][Pickup]))
					{
						new Float:Pos[3];
						GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
					    DestroyDynamicPickup(Dyn[id][Pickup]);
					    CreateDynamicPickup(Dyn[id][pid], 1, Pos[0], Pos[1], Pos[2]);
						SendClientMessage(playerid, -1, "{dbdbdb}[DYN] Dyn-Pickup Location Changed.");
						Dyn[id][x] = Pos[0];
						Dyn[id][y] = Pos[1];
						Dyn[id][z] = Pos[2];
 	    				DestroyDynamic3DTextLabel(Text3D:Text[id][text1]);
	    				DestroyDynamic3DTextLabel(Text3D:Text[id][text1]);
 						DestroyDynamic3DTextLabel(Text3D:Text[id][text2]);
				   		DestroyDynamic3DTextLabel(Text3D:Text[id][text3]);
					    DestroyDynamic3DTextLabel(Text3D:Text[id][text4]);
					    DestroyDynamic3DTextLabel(Text3D:Text[id][text5]);
					    DestroyDynamic3DTextLabel(Text3D:Text[id][text6]);
					    DestroyDynamic3DTextLabel(Text3D:Text[id][text7]);
					    DestroyDynamic3DTextLabel(Text3D:Text[id][text8]);
    					Text[id][text1] = CreateDynamic3DTextLabel(Text[id][cnt1], 0xFFFF00FF, Float:Pos[0], Float:Pos[1], Float:Pos[2] + 1.0, 20.0);
    					Text[id][text2] = CreateDynamic3DTextLabel(Text[id][cnt2], 0xFFFF00FF, Float:Pos[0], Float:Pos[1], Float:Pos[2] + 1.5, 20.0);
    					if(Text[id][text3] != Text3D:-1)
    					{
           					Text[id][text3] = Text3D:CreateDynamic3DTextLabel(Text[id][cnt3], 0xFFFF00FF, Float:Pos[0], Float:Pos[1], Float:Pos[2] + 2.0, 20.0);
						}
						if(Text[id][text4] != Text3D:-1)
    					{
           					Text[id][text4] = Text3D:CreateDynamic3DTextLabel(Text[id][cnt4], 0xFFFF00FF, Float:Pos[0], Float:Pos[1], Float:Pos[2] + 3.0, 20.0);
						}
						if(Text[id][text5] != Text3D:-1)
    					{
           					Text[id][text5] = Text3D:CreateDynamic3DTextLabel(Text[id][cnt5], 0xFFFF00FF, Float:Pos[0], Float:Pos[1], Float:Pos[2] + 4.0, 20.0);
						}
						if(Text[id][text6] != Text3D:-1)
    					{
           					Text[id][text6] = Text3D:CreateDynamic3DTextLabel(Text[id][cnt6], 0xFFFF00FF, Float:Pos[0], Float:Pos[1], Float:Pos[2], 20.0);
						}
						if(Text[id][text7] != Text3D:-1)
    					{
           					Text[id][text7] = Text3D:CreateDynamic3DTextLabel(Text[id][cnt7], 0xFFFF00FF, Float:Pos[0], Float:Pos[1], Float:Pos[2] - 1.0, 20.0);
						}
						if(Text[id][text8] != Text3D:-1)
    					{
           					Text[id][text8] = Text3D:CreateDynamic3DTextLabel(Text[id][cnt8], 0xFFFF00FF, Float:Pos[0], Float:Pos[1], Float:Pos[2] - 2.0, 20.0);
						}
					}
					else
					{
						SendClientMessage(playerid, -1, "{dbdbdb}[DYN] Invalid Dyn Pickup.");
					}
				}
			}
		}
	}
	return 1;
}

CMD:smthg(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
	    if(IsPlayerAdmin(playerid))
	    {
			for(new i;i > MAX_DYNCP;i++)
			{
			    if(DynCP[i][cpused] == false)
			    {
					new Float:Pos[3];
					GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
					DynCP[i][cpused] = true;
					DynCP[i][CP] = CreateDynamicCP(Pos[0], Pos[1], Pos[1], 3.0);
					SendClientMessage(playerid, -1, "{dbdbdb}[DYNCP] Created a Dynamic CP at your pos!");
				}
			}
		}
	}
	return 1;
}
