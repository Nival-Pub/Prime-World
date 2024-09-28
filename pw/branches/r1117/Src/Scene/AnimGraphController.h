// Author: EugBel
// Date:   14/05/2009

#pragma once

#include "DiAnGr.h"

namespace NScene
{

struct SavedTransactionInfo
{
  uint nodeFromID;
  uint nodeToID;
  float minStartPar;
  float maxStartPar;
};

enum RandomNodeSelectType
{
  RNST_Normal,
  RNST_Dispatcher,
  RNST_SubNode,
};

class AnimGraphController : public NonCopyable
{
public:

  AnimGraphController(DiAnimGraph *graphToControl, const vector<NDb::Animation> &animations);
  ~AnimGraphController();

  void SetNodeInfo( int nodeIdx, const NDb::AnGrMacronode& nodeInfo );
  void SetSequenceInfo( int nodeIdx, int seqIdx, const NDb::AnGrFormula& startPar, const NDb::AnGrFormula& stopPar, 
                        const NDb::AnGrFormula& speed, const nstl::string& name );
  // ��� ������� � ���� ����������� float � �� float ����������, ���� �� ������� ��� �������
  void SetFlMultiTransactionsInfo( int fromNodeIdx, int toNodeIdx, const NDb::AnGrFlMultiTransaction& transactionInfo );
  void SetFlTransactionsInfo( int fromNodeIdx, int toNodeIdx, int partIdx, const NDb::AnGrFlTransaction& partInfo );

  void ReloadAG(); // ������������� AG �� ���� ������
  void PlayNodes( const vector<int> &nodeIndices, float _loopTime ); // ��������� node's � ��������� �������
  void SetGlobalSpeed( float speed ); // ���������� ���������� �������� ������������ ��������
  
  void SetVirtualParameter( int nodeIdx, float value ); // ���������� �������� �� node � "�������" float
  void ResetVirtualParameter(); // ��������� � ����������� ��������������� AG
  
  void GetActiveEntity( int* pNodeIdx, int* pFromNodeIdx, int* pToNodeIdx, bool isGetDispatcher = false ) const; // ����� -1, ���� �� � ����/�� � ����������
  int  GetCurTargetNode() { return m_nodesToPlay[m_curTargetIdx]; }
  bool GetCurNodeSurfSpeed(CVec2 &surfSpeed);

  void SetNextNode(int nodeId) { m_graph->SetNextNode(nodeId); }
  RandomNodeSelectType GetRandomNodeSelectType() { return randomNodeSelectType; }

private:
  int             GetSeqIDByNameSlow(const string &name);
  const char*     GetSeqNameByID(int ID);
  void            RegisterPlayNodesCallbacks();
  void            UnregisterPlayNodesCallbacks();

  DiAnimGraph                   *m_graph; // direct link to AnimGraph
  const vector<NDb::Animation>  &m_animations;
  
  vector<int>                   m_nodesToPlay;
  int                           m_curTargetIdx; // index in vector m_nodesToPlay
  RandomNodeSelectType randomNodeSelectType; // 0 - normal, 1 - dispatcher, 2 - subnode

  void SetTransactionParams( uint from, uint to, float min, float max );
  void GetTransactionParams( uint from, uint to, float* min, float* max );

  // ���������� ��������� ��� ������������ �������� ��� ( ������� ��������, ����� ������ ���� ���� ������ )
  bool isSavedTransactionParams;
  nstl::vector<SavedTransactionInfo> savedInfos;

  // ������� ��������� ������� � ����������� ����
  float loopTime;
  int numLoopCycle;

friend DiInt32 EnterNodeCallbackFunction(const DiAnGrCallbackParams& params);
friend DiInt32 EndNodeCallbackFunction(const DiAnGrCallbackParams& params);
friend DiInt32 LoopNodeCallbackFunction(const DiAnGrCallbackParams& params);
friend int GetCurrentNodeIdx(AnimGraphController *ctrl);
friend int GetCurrentNodeIdx(AnimGraphController *ctrl);
friend void UnregisterCallbacksForLoopedNode( AnimGraphController *ctrl, int nodeIdx );
friend float CalcRegTime( AnimGraphController *ctrl, float nodeLength );
friend bool PlayDispatcherLoopedNodeTime( AnimGraphController *ctrl, int nodeIdx );
friend bool PlayNormalLoopedNodeTime( AnimGraphController *ctrl, int nodeIdx );
friend bool PlayLoopedNodeTime( AnimGraphController *ctrl, int nodeIdx );
};


} // namespace NScene
