using UnityEngine;
using System.Collections;

public class SpriteAtlas : MonoBehaviour
{
	void FixedUpdate ()
    {
        float timeValue = Mathf.Ceil(Time.time % 16);
        GetComponent<MeshRenderer>().material.SetFloat("_TimeValue", timeValue);
    }
}
